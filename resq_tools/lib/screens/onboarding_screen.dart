import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq_tools/blocs/onboarding_cubit.dart';
import 'package:resq_tools/main.dart';
import 'package:resq_tools/utils/extensions.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const int maxTokenLength = 28;

  final TextEditingController _tokenController = TextEditingController();
  bool isTokenValid = false;
  bool isTokenObscured = true;
  bool isDemoSystem = true;
  String appToken = '';

  @override
  void initState() {
    super.initState();

    final state = context.read<OnboardingCubit>().state;

    if (state.appToken != null && state.appToken!.isNotEmpty) {
      _tokenController.text = state.appToken!;
      appToken = state.appToken!;
      isTokenValid = appToken.length >= maxTokenLength;
    }

    isDemoSystem = state.isDemoSystem;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<OnboardingCubit, OnboardingState>(
        builder: (context, state) {
          return _onboardingWidget(state);
        },
      ),
    );
  }

  Widget _onboardingWidget(OnboardingState state) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(
                  maxHeight: 175,
                  maxWidth: 175,
                ),
                child: Image.asset('assets/app_icon.png'),
              ),
              const SizedBox(height: 32),
              Text(
                context.l10n?.app_name ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
              _getAppTokenCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getAppTokenCard() => Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            context.l10n?.onboarding_app_token_description ?? '',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _tokenController,
            obscureText: isTokenObscured,
            keyboardType: TextInputType.text,
            inputFormatters: [LengthLimitingTextInputFormatter(maxTokenLength)],
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              hintText: context.l10n?.onboarding_app_token_hint,
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: context.l10n?.onboarding_app_token_label,
              counterText: '${appToken.length}/$maxTokenLength',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      isTokenObscured ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        isTokenObscured = !isTokenObscured;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _tokenController.clear();
                        appToken = '';
                        isTokenValid = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            onChanged: (value) {
              setState(() {
                appToken = value;
                isTokenValid = appToken.length >= maxTokenLength;
              });
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Switch(
                value: isDemoSystem,
                onChanged: (value) {
                  setState(() {
                    isDemoSystem = value;
                  });
                },
              ),
              Text(
                context.l10n?.onboarding_demo_system ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  _navigateToNextScreen();
                },
                child: Text(context.l10n?.onboarding_set_token_later ?? ''),
              ),
              FilledButton(
                onPressed:
                    isTokenValid
                        ? () {
                          context.read<OnboardingCubit>().setOnboardingDetails(
                            appToken,
                            isDemoSystem,
                          );
                          _navigateToNextScreen();
                        }
                        : null,
                child: Text(
                  context.l10n?.onboarding_set_token ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  void _navigateToNextScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ResQToolsHomePage()),
    );
  }
}
