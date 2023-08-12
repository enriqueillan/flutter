import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:oauth2/oauth2.dart';
import 'package:repo_viewer/auth/domain/auth_failure.dart';
import 'package:repo_viewer/auth/infraestructure/credentials_storage/credentials_storage.dart';
import 'package:http/http.dart' as http;

class GithubOAuthHttpClient extends http.BaseClient {
  final httpClient = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Accept'] = 'application/json';
    return httpClient.send(request);
  }
}

class GithubAuthenticator {
  final CredentialsStorage _credentialsStorage;
  final Dio _dio;

  GithubAuthenticator(this._credentialsStorage, this._dio);

  static final autorizationEndpoint =
      Uri.parse('https://github.com/login/oauth/authorize');
  static final tokenEndpoint =
      Uri.parse('https://github.com/login/oauth/access_token');
  static final redirectUrl = Uri.parse('http://localhost:3000/callback');

  static const clientId = '44027ad5b26d2bcb7058';
  static const clientSecret = '8daea42605e7787b54200a1fe79e65a3ca0af255';
  static const scopes = ['read:user', 'repo'];

  Future<Credentials?> getSignedInCredentials() async {
    final storedCredentials = await _credentialsStorage.read();

    if (storedCredentials != null) {
      if (storedCredentials.canRefresh && storedCredentials.isExpired) {
        // TODO: Refresh token
      }
    }
    return storedCredentials;
  }

  Future<bool> isSignIn() =>
      getSignedInCredentials().then((credentials) => credentials != null);

  AuthorizationCodeGrant createGrant() {
    return AuthorizationCodeGrant(clientId, autorizationEndpoint, tokenEndpoint,
        secret: clientSecret, httpClient: GithubOAuthHttpClient());
  }

  Uri getAutorizationUrl(AuthorizationCodeGrant grant) {
    return grant.getAuthorizationUrl(redirectUrl, scopes: scopes);
  }

  Future<Either<AuthFailure, Unit>> handleAutorizationResponse(
      AuthorizationCodeGrant grant, Map<String, String> queryParams) async {
    try {
      final httpClient = await grant.handleAuthorizationResponse(queryParams);
      await _credentialsStorage.save(httpClient.credentials);
      return right(unit);
    } on FormatException {
      return left(const AuthFailure.server());
    } on AuthorizationException catch (e) {
      return left(AuthFailure.server('${e.error}:${e.description}'));
    } on PlatformException {
      return left(AuthFailure.storage());
    }
  }

  Future<Either<AuthFailure, Unit>> singOut() async {
    try {
      await _credentialsStorage.clear();
      return right(unit);
    } on PlatformException {
      return left(const AuthFailure.storage());
    }
  }
}
