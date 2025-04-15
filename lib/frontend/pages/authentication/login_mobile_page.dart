// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/design/screen_size.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/widgets/components/buttons/third_party_button.dart';
import 'package:transcript_of_records/frontend/widgets/components/text/standard_text.dart';
import 'package:transcript_of_records/frontend/widgets/components/useful_widgets/loading_spin.dart';

class LoginMobile extends ConsumerWidget {

  const LoginMobile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final appTheme = ref.read(appThemeProvider);
    final authApi = ref.read(authApiProvider);
    final userStateNotifier = ref.read(userStateProvider.notifier);

    // Closing the loading spin after the build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingSpin.closeLoadingSpin(context);
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didpop, _) async {
        if (!didpop) {}
      },
      child: Scaffold(
        backgroundColor: appTheme.primaryColor,
        appBar: AppBar(
            centerTitle: true,
            title: const StandardText(text: 'Anmelden', color: Colors.black),
            backgroundColor: appTheme.secondaryColor
        ),
        body: SizedBox(
          width: ScreenSize.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ThirdPartyButton(
                imageName: 'Google',
                onPressed: () async {
                  await authApi.googleLogin(context);
                  await userStateNotifier.checkUserStatus(ref: ref);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
