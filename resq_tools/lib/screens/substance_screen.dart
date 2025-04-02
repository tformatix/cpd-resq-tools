import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/substance_cubit.dart';
import 'package:resq_tools/utils/extensions.dart';

class SubstanceScreen extends StatelessWidget {
  const SubstanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n?.substance_title ?? '')),
      body: Center(
        child: BlocBuilder<SubstanceCubit, SubstanceState>(
          builder: (context, state) {
            return state.isLoading
                ? const CircularProgressIndicator()
                : Text(state.dummyString ?? 'No data');
          },
        ),
      ),
    );
  }
}
