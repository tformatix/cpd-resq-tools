import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/substance_cubit.dart';
import 'package:resq_tools/utils/extensions.dart';
import 'package:resq_tools/models/substance/substance_result.dart';

class SubstanceScreen extends StatefulWidget {
  const SubstanceScreen({super.key});

  @override
  State<SubstanceScreen> createState() => _SubstanceScreenState();
}

class _SubstanceScreenState extends State<SubstanceScreen> {
  final TextEditingController _textEditingController = TextEditingController();

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
            _showSubstanceSearchContainer(context),

            const SizedBox(height: 48),

            _showSubstanceResult(context, state),
          ],
        ),
      ),
    );
  }

  Widget _showSubstanceSearchContainer(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: context.l10n?.substance_textfield_label,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.camera_alt),
              onPressed: () {
                // TODO: implement camera
              },
            ),
          ],
        ),

        Padding(
          padding: EdgeInsets.only(top: 16.0),
          child: FilledButton(
            onPressed: () {
              // Trigger search in your cubit:
              context.read<SubstanceCubit>().fetchSubstance(
                _textEditingController.text,
              );
            },
            child: Text('${context.l10n?.substance_search}'),
          ),
        ),
      ],
    );
  }

  Widget _showSubstanceResult(BuildContext context, SubstanceState state) {
    final substance = state.substance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (state.isError)
          const Text('An error occurred', style: TextStyle(color: Colors.red))
        else if (state.isLoading)
          const Center(child: CircularProgressIndicator())
        else if (substance != null)
          _showSubstanceDetails(context, substance),
      ],
    );
  }

  Widget _showSubstanceDetails(BuildContext context, SubstanceResult substance) {
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