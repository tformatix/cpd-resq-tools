import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/resistance_cubit.dart';
import 'package:resq_tools/utils/extensions.dart';

class ResistanceScreen extends StatelessWidget {
  const ResistanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n?.resistance_title ?? '')),
      body: Center(
        child: BlocBuilder<ResistanceCubit, ResistanceState>(
          builder: (context, state) {
            return state.isLoading
                ? CircularProgressIndicator()
                : Text(state.dummyString ?? 'No data');
          },
        ),
      ),
    );
  }
}
