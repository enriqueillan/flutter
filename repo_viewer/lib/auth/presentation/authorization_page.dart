import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:repo_viewer/auth/infraestructure/github_authenticator.dart';
import 'package:webview_flutter/webview_flutter.dart';

@RoutePage()
class AuthorizationPage extends StatefulWidget {
  const AuthorizationPage(
      {super.key,
      required this.authorizationUrl,
      required this.onAuthorizationCodeRedirectAttemp});

  final Uri authorizationUrl;

  final void Function(Uri redirectUrl) onAuthorizationCodeRedirectAttemp;

  @override
  State<AuthorizationPage> createState() => _AuthorizationPageState();
}

class _AuthorizationPageState extends State<AuthorizationPage> {
  late final WebViewController controller;

  @override
  void initState() {
    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onNavigationRequest: (navReq) {
          if (navReq.url
              .startsWith(GithubAuthenticator.redirectUrl.toString())) {
            widget.onAuthorizationCodeRedirectAttemp(Uri.parse(navReq.url));
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.authorizationUrl.toString())).then(
        (value) {
          controller.clearCache();
          WebViewCookieManager().clearCookies();
        },
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: WebViewWidget(controller: controller)),
    );
  }
}
