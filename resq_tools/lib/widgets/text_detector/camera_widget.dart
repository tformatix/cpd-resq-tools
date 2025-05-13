import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class CameraWidget extends StatefulWidget {
  final Function(InputImage inputImage)? onImage;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final Widget submitButton;
  final CameraLensDirection initialCameraLensDirection;

  const CameraWidget({
    super.key,
    required this.onImage,
    this.onCameraLensDirectionChanged,
    this.submitButton = const SizedBox(),
    this.initialCameraLensDirection = CameraLensDirection.back,
  });

  @override
  State<CameraWidget> createState() => _CameraWidgetState();
}

class _CameraWidgetState extends State<CameraWidget> {
  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  int _cameraIndex = -1;
  bool _changingCameraLens = false;

  @override
  void initState() {
    super.initState();

    _initialize();
  }

  void _initialize() async {
    if (_cameras.isEmpty) {
      _cameras = await availableCameras();
    }
    for (var i = 0; i < _cameras.length; i++) {
      if (_cameras[i].lensDirection == widget.initialCameraLensDirection) {
        _cameraIndex = i;
        break;
      }
    }
    if (_cameraIndex != -1) {
      _startLiveFeed();
    }
  }

  @override
  void dispose() {
    _stopLiveFeed();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isReady =
        !_changingCameraLens &&
        _cameras.isNotEmpty &&
        _controller != null &&
        _controller?.value.isInitialized == true;

    return isReady
        ? Stack(
          alignment: Alignment.center,
          children: [
            CameraPreview(_controller!),
            _zoomControl(),
            _switchLiveCameraToggle(),
            _submitButton(),
          ],
        )
        : const Padding(
          padding: EdgeInsets.all(12),
          child: CircularProgressIndicator(),
        );
  }

  Widget _switchLiveCameraToggle() => Positioned(
    bottom: 16,
    right: 16,
    child: FloatingActionButton(
      onPressed: _switchLiveCamera,
      child: Icon(
        Platform.isIOS
            ? Icons.flip_camera_ios_outlined
            : Icons.flip_camera_android_outlined,
        size: 25,
      ),
    ),
  );

  Widget _zoomControl() => Positioned(
    top: 16,
    right: 16,
    child: RotatedBox(
      quarterTurns: 3,
      child: SizedBox(
        width: 250,
        child: Slider(
          value: _currentZoomLevel,
          min: _minAvailableZoom,
          max: _maxAvailableZoom,
          activeColor: Colors.white,
          inactiveColor: Colors.white30,
          onChanged: (value) async {
            setState(() {
              _currentZoomLevel = value;
            });
            await _controller?.setZoomLevel(value);
          },
        ),
      ),
    ),
  );

  Widget _submitButton() => Positioned(bottom: 16, child: widget.submitButton);

  Future _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup:
          Platform.isAndroid
              ? ImageFormatGroup.nv21
              : ImageFormatGroup.bgra8888,
    );
    _controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }

      _controller?.getMinZoomLevel().then((value) {
        _currentZoomLevel = value;
        _minAvailableZoom = value;
      });
      _controller?.getMaxZoomLevel().then((value) {
        _maxAvailableZoom = value;
      });

      _controller?.startImageStream(_processCameraImage).then((value) {
        if (widget.onCameraLensDirectionChanged != null) {
          widget.onCameraLensDirectionChanged!(camera.lensDirection);
        }
      });
      setState(() {});
    });
  }

  Future _stopLiveFeed() async {
    await _controller?.stopImageStream();
    await _controller?.dispose();
    _controller = null;
  }

  Future _switchLiveCamera() async {
    setState(() => _changingCameraLens = true);
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;

    await _stopLiveFeed();
    await _startLiveFeed();
    setState(() => _changingCameraLens = false);
  }

  void _processCameraImage(CameraImage image) {
    if (widget.onImage != null) {
      final inputImage = _inputImageFromCameraImage(image);
      if (inputImage == null) return;
      widget.onImage!(inputImage);
    }
  }

  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }
    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);

    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.length != 1) return null;
    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }
}
