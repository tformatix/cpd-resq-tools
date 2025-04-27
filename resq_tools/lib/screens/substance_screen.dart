import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/substance_cubit.dart';
import 'package:resq_tools/models/common/camera_ocr_type.dart';
import 'package:resq_tools/models/substance/substance_result.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/widgets/substance/substance_result_widget.dart';
import 'package:resq_tools/widgets/text_field_camera_search.dart';
import 'package:url_launcher/url_launcher.dart';

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
              labelText: context.l10n?.substance_text_field_label,
              isLoading: state.isLoading,
              inputFormatters: [
                LengthLimitingTextInputFormatter(4),
                FilteringTextInputFormatter.digitsOnly,
              ],
              ocrType: CameraOcrType.substance,
              onSearchClicked:
                  (String unNumber) =>
                      context.read<SubstanceCubit>().fetchSubstances(
                        unNumber,
                        Localizations.localeOf(context).languageCode,
                      ),
            ),

            const SizedBox(height: 32),

            if (!state.isLoading && !state.isInitialState)
              _showSubstanceResult(context, state),
          ],
        ),
      ),
    );
  }

  Widget _showSubstanceResult(BuildContext context, SubstanceState state) {
    if (state.isError) {
      return Text(
        '${context.l10n?.substance_error}',
        style: TextStyle(color: Theme.of(context).colorScheme.error),
        textAlign: TextAlign.center,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.isEmptyResult)
          Text('${context.l10n?.substance_no_result}')
        else
          _showSubstanceList(context, state.substancesList),
      ],
    );
  }

  Widget _showSubstanceList(
    BuildContext context,
    List<SubstanceResult>? substancesList,
  ) {
    if (substancesList == null) return const SizedBox.shrink();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: substancesList.length,
      itemBuilder: (context, index) {
        final substance = substancesList[index];
        return Column(
          children: [
            if (index > 0) const SizedBox(height: 4),

            SubstanceResultWidget(
              casNumber: substance.casNumber,
              name: substance.name,
              onTap: () {
                final url = substance.detailUrl;

                if (url != null) {
                  launchUrl(url, mode: LaunchMode.externalApplication);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
