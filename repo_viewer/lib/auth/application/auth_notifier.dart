import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:repo_viewer/auth/infraestructure/github_authenticator.dart';

import '../domain/auth_failure.dart';

part 'auth_notifier.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.authenticated() = _Authenticated;
  const factory AuthState.failure(AuthFailure failure) = _Failure;
}

typedef AuthUriCallback = Future<Uri> Function(Uri authorizationUrl);

class AuthNotifier extends StateNotifier<AuthState> {
  final GithubAuthenticator _authenticator;

  AuthNotifier(this._authenticator) : super(const AuthState.initial());

  Future<void> checkAndUpdateAuthStatus() async {
    state = (await _authenticator.isSignIn())
        ? const AuthState.authenticated()
        : const AuthState.unauthenticated();
  }

  Future<void> signIn(AuthUriCallback authorizationUriCallback) async {
    final grant = _authenticator.createGrant();
    final redirectUrl = await authorizationUriCallback(
        _authenticator.getAutorizationUrl(grant));
    final failureOrSuccess = await _authenticator.handleAutorizationResponse(
        grant, redirectUrl.queryParameters);

    state = failureOrSuccess.fold(
      (l) => AuthState.failure(l),
      (r) => AuthState.authenticated(),
    );

    grant.close();
  }

  Future<void> signOut() async {
    final failureOrSuccess = await _authenticator.singOut();
    state = failureOrSuccess.fold(
      (l) => AuthState.failure(l),
      (r) => AuthState.unauthenticated(),
    );
  }
}
