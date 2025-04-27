import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resq_tools/blocs/blattler_cubit.dart';
import 'package:resq_tools/blocs/camera_cubit.dart';
import 'package:resq_tools/blocs/rescue_sheet_cubit.dart';
import 'package:resq_tools/blocs/resistance_cubit.dart';
import 'package:resq_tools/blocs/substance_cubit.dart';
import 'package:resq_tools/l10n/l10n.dart';
import 'package:resq_tools/repositories/blattler_repository.dart';
import 'package:resq_tools/repositories/camera_repository.dart';
import 'package:resq_tools/repositories/rescue_sheet/euro_rescue_repository.dart';
import 'package:resq_tools/repositories/rescue_sheet/licence_plate_repository.dart';
import 'package:resq_tools/repositories/resistance_repository.dart';
import 'package:resq_tools/repositories/substance_repository.dart';
import 'package:resq_tools/screens/blattler_screen.dart';
import 'package:resq_tools/screens/rescue_sheet_screen.dart';
import 'package:resq_tools/screens/resistance_screen.dart';
import 'package:resq_tools/screens/substance_screen.dart';
import 'package:resq_tools/utils/extensions.dart';

void main() {
  runApp(const ResQToolsApp());
}

class ResQToolsApp extends StatelessWidget {
  const ResQToolsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final licencePlateRepository = LicencePlateRepository();
    final euroRescueRepository = EuroRescueRepository();
    final resistanceRepository = ResistanceRepository();
    final substanceRepository = SubstanceRepository();
    final blattlerRepository = BlattlerRepository();
    final cameraRepository = CameraRepository();

    const localizationsDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create:
              (_) => RescueSheetCubit(
                licencePlateRepository,
                euroRescueRepository,
              ),
        ),
        BlocProvider(create: (_) => ResistanceCubit(resistanceRepository)),
        BlocProvider(create: (_) => SubstanceCubit(substanceRepository)),
        BlocProvider(create: (_) => BlattlerCubit(blattlerRepository)),
        BlocProvider(create: (_) => CameraCubit(cameraRepository)),
      ],
      child: MaterialApp(
        title: 'ResQTools',
        localizationsDelegates: localizationsDelegates,
        supportedLocales: L10n.all,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        ),
        home: const ResQToolsHomePage(),
      ),
    );
  }
}

class ResQToolsHomePage extends StatefulWidget {
  const ResQToolsHomePage({super.key});

  @override
  State<ResQToolsHomePage> createState() => _ResQToolsHomePageState();
}

class _ResQToolsHomePageState extends State<ResQToolsHomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Theme.of(context).colorScheme.primary,
        selectedIndex: currentPageIndex,
        destinations: <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.car_crash,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            icon: const Icon(Icons.car_crash_outlined),
            label: context.l10n?.rescue_sheet_title ?? '',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.calculate,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            icon: const Icon(Icons.calculate_outlined),
            label: context.l10n?.resistance_title ?? '',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.warning,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            icon: const Icon(Icons.warning_outlined),
            label: context.l10n?.substance_title ?? '',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.description,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            icon: const Icon(Icons.description_outlined),
            label: context.l10n?.blattler_title ?? '',
          ),
        ],
      ),
      body:
          <Widget>[
            const RescueSheetScreen(),
            const ResistanceScreen(),
            const SubstanceScreen(),
            const BlattlerScreen(),
          ][currentPageIndex],
    );
  }
}
