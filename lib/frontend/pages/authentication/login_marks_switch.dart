// author: Lukas Horst

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transcript_of_records/backend/riverpod/provider.dart';
import 'package:transcript_of_records/frontend/pages/authentication/login_mobile_page.dart';
import 'package:transcript_of_records/frontend/pages/marks_mobile_page.dart';

// Switch between the login page and the marks page
class LoginMarksSwitch extends ConsumerWidget {
  const LoginMarksSwitch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userStateProvider);
    if (userState.user == null) {
      if (userState.firstCheck) {
        return const LoginMobile();
      } else {
        return const Scaffold();
      }
    } else {
      return const MarksMobile();
    }
  }
}
