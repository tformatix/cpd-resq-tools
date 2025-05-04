import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:flutter/services.dart';

class AngleMeasurementScreen extends StatefulWidget {
  const AngleMeasurementScreen({super.key});

  @override
  State<AngleMeasurementScreen> createState() => _AngleMeasurementScreenState();
}

class _AngleMeasurementScreenState extends State<AngleMeasurementScreen> {
  late StreamSubscription<AccelerometerEvent> _subscription;
  double _angle = 0.0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    _subscription = accelerometerEventStream().listen((event) {
      final radians = atan2(event.y, event.x);
      final degrees = radians * (180 / pi);
      setState(() {
        _angle = degrees;
      });
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final waterColor = Theme.of(context).colorScheme.secondary;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.of(context).pop(_angle.abs());
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Stack(
          alignment: Alignment.center,
          children: [
            CustomPaint(
              size: size,
              painter: _LevelPainter(_angle, waterColor),
            ),
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  '${_angle.abs().toStringAsFixed(1)}°',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  context.l10n?.angle_measurement_exit
                      ?? 'Tap to exit',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelPainter extends CustomPainter {
  final double angle;
  final Color waterColor;
  _LevelPainter(this.angle, this.waterColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paintWater = Paint()..color = waterColor;
    final paintLine = Paint()
      ..color = Colors.white
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(angle * pi / 180);

    final fillRect = Rect.fromLTWH(
      -size.width,
      0,
      size.width * 2,
      size.height,
    );
    canvas.drawRect(fillRect, paintWater);

    canvas.drawLine(
      Offset(-size.width, 0),
      Offset(size.width, 0),
      paintLine,
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _LevelPainter oldPainter) {
    return oldPainter.angle != angle;
  }
}
