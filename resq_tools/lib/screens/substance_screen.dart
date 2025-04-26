import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/substance_cubit.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/models/substance/substance_result.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/widgets/text_field_camera_search.dart';

class SubstanceScreen extends StatelessWidget {
  const SubstanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${context.l10n?.substance_title}')),
      body: BlocBuilder<SubstanceCubit, SubstanceState>(
        builder: (context, state) {
          return _getSubstanceWidget(context, state);
        },
      ),
    );
  }

  Widget _getSubstanceWidget(BuildContext context, SubstanceState state) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFieldCameraSearch(
              labelText: context.l10n?.substance_textfield_label,
              isLoading: state.isLoading,
              onSearchClicked:
                  (String text) =>
                      context.read<SubstanceCubit>().fetchSubstance(text),
              ocrType: CameraOcrType.substance,
            ),

            const SizedBox(height: 48),

            _showSubstanceResult(context, state),
          ],
        ),
      ),
    );
  }

  Widget _showSubstanceResult(BuildContext context, SubstanceState state) {
    final substance = state.substance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.isError)
          const Text('An error occurred', style: TextStyle(color: Colors.red))
        else if (substance != null)
          _showSubstanceDetails(context, substance),
      ],
    );
  }

  Widget _showSubstanceDetails(
    BuildContext context,
    SubstanceResult substance,
  ) {
    final l10n = context.l10n;

    const double textFontSize = 16.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: textFontSize),
            children: [
              TextSpan(
                text: '${l10n?.substance_name}: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: substance.name),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: textFontSize),
            children: [
              TextSpan(
                text: '${l10n?.substance_hazard_number}: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '${substance.hazardNumber}'),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: textFontSize),
            children: [
              TextSpan(
                text: '${l10n?.substance_un_number}: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: '${substance.unNumber}'),
            ],
          ),
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(fontSize: textFontSize),
            children: [
              TextSpan(
                text: '${l10n?.substance_properties}: ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: substance.properties),
            ],
          ),
        ),
      ],
    );
  }
}
