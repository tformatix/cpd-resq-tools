import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/blattler_cubit.dart';
import 'package:resq_tools/utils/extensions.dart';

class BlattlerScreen extends StatelessWidget {
  const BlattlerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n?.blattler_title ?? '')),
      body: Center(
        child: BlocBuilder<BlattlerCubit, BlattlerState>(
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
