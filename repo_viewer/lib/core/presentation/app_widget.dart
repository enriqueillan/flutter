import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/auth/application/auth_notifier.dart';
import 'package:repo_viewer/auth/shared/providers.dart';
import 'package:repo_viewer/core/presentation/routes/app_router.dart';

final initializationProvider = FutureProvider((ref) async {
  final authNotifier = ref.read(authNotifierProvider.notifier);
  await authNotifier.checkAndUpdateAuthStatus();
});

class AppWidget extends ConsumerWidget {
  /// create an instance of `AppRouter`
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(initializationProvider);

    ref.listen<AuthState>(authNotifierProvider,
        (AuthState? previous, AuthState next) {
      next.maybeMap(
        orElse: () {
          print('Unkown state');
        },
        authenticated: (value) {
          print('Authenticated');
          _appRouter.pushAndPopUntil(
            const StarredReposRoute(),
            predicate: (route) => false,
          );
        },
        unauthenticated: (value) {
          print('Unauthenticated');
          _appRouter.pushAndPopUntil(
            const SignInRoute(),
            predicate: (route) => false,
          );
        },
        failure: (value) {
          print('Failure');
        },
      );
    });

    return MaterialApp.router(
      title: 'Repo Viewer',
      routerConfig: _appRouter.config(),
    );
  }
}
