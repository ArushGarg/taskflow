import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../tasks/presentation/pages/task_list_page.dart';
import '../bloc/auth_bloc.dart';
import 'login_page.dart';

/// Root-level widget that swaps between auth flow and the task list based
/// on AuthBloc's status. Keeps main.dart free of navigation logic.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        switch (state.status) {
          case AuthStatus.authenticated:
            return const TaskListPage();
          case AuthStatus.unauthenticated:
            return const LoginPage();
          case AuthStatus.unknown:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
        }
      },
    );
  }
}