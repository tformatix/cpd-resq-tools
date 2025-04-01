import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/rescue_sheet_cubit.dart';
import 'package:resq_tools/utils/extensions.dart';

class RescueSheetScreen extends StatelessWidget {
  const RescueSheetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n?.rescue_card_title ?? '')),
      body: Center(
        child: BlocBuilder<RescueSheetCubit, RescueSheetState>(
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
