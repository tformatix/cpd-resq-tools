import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resq_tools/blocs/blattler_cubit.dart';
import 'package:resq_tools/blocs/onboarding_cubit.dart';
import 'package:resq_tools/blocs/rescue_sheet_cubit.dart';
import 'package:resq_tools/blocs/resistance_cubit.dart';
import 'package:resq_tools/blocs/settings_cubit.dart';
import 'package:resq_tools/blocs/substance_cubit.dart';
import 'package:resq_tools/l10n/l10n.dart';
import 'package:resq_tools/repositories/blattler_repository.dart';
import 'package:resq_tools/repositories/rescue_sheet/euro_rescue_repository.dart';
import 'package:resq_tools/repositories/rescue_sheet/licence_plate_repository.dart';
import 'package:resq_tools/repositories/resistance_repository.dart';
import 'package:resq_tools/repositories/settings_repository.dart';
import 'package:resq_tools/repositories/storage_repository.dart';
import 'package:resq_tools/repositories/substance_repository.dart';
import 'package:resq_tools/screens/blattler_screen.dart';
import 'package:resq_tools/screens/onboarding_screen.dart';
import 'package:resq_tools/screens/rescue_sheet_screen.dart';
import 'package:resq_tools/screens/resistance_screen.dart';
import 'package:resq_tools/screens/substance_screen.dart';
import 'package:resq_tools/theme/resq_tools_theme.dart';
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
    final storageRepository = StorageRepository();
    final settingsRepository = SettingsRepository();

    const localizationsDelegates = [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ResistanceCubit(resistanceRepository)),
        BlocProvider(
          create:
              (_) => RescueSheetCubit(
                licencePlateRepository,
                euroRescueRepository,
                storageRepository,
              ),
        ),
        BlocProvider(create: (_) => SubstanceCubit(substanceRepository)),
        BlocProvider(create: (_) => BlattlerCubit(blattlerRepository)),
        BlocProvider(
          create: (_) {
            final onboardingCubit = OnboardingCubit(storageRepository);
            onboardingCubit.fetchOnboardingDetails();
            return onboardingCubit;
          },
        ),
        BlocProvider(create: (_) => SettingsCubit(settingsRepository)),
      ],
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (prev, curr) => prev.hashCode != curr.hashCode,
        builder: (context, state) {
          return MaterialApp(
            title: 'ResQTools',
            localizationsDelegates: localizationsDelegates,
            supportedLocales: L10n.all,
            locale: state.languageLocale,
            theme: ResQToolsTheme.lightTheme,
            darkTheme: ResQToolsTheme.darkTheme,
            debugShowCheckedModeBanner: false,
            themeMode: state.themeMode,
            home: FutureBuilder<String?>(
              future: storageRepository.getAppToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Scaffold(
                    body: Center(child: CircularProgressIndicator()),
                  );
                }

                final token = snapshot.data;
                return (token == null || token.isEmpty)
                    ? const OnboardingScreen()
                    : const ResQToolsHomePage();
              },
            ),
          );
        },
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
