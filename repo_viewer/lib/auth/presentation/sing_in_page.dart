import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:repo_viewer/auth/shared/providers.dart';
import 'package:repo_viewer/core/presentation/routes/app_router.dart';

@RoutePage()
class SignInPage extends ConsumerWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    MdiIcons.github,
                    size: 150,
                  ),
                  Text(
                    'Welcome to\n Repo Viewer',
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      ref
                          .read(authNotifierProvider.notifier)
                          .signIn((authorizationUrl) {
                        final completer = Completer<Uri>();
                        AutoRouter.of(context).push(
                          AuthorizationRoute(
                            authorizationUrl: authorizationUrl,
                            onAuthorizationCodeRedirectAttemp: (redirectUrl) {
                              completer.complete(redirectUrl);
                            },
                          ),
                        );
                        return completer.future;
                      });
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green)),
                    child: Text('Sign In'),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
