import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:go_router_plus_example/main.dart';

void main() {
  testWidgets('test app using Go Router plus', (tester) async {
    final authService = AuthService();
    final router = createGoRouter(
      screens: [
        LoginScreen(authService),
        HomeScreen(authService),
      ],
      redirectors: [
        ScreenRedirector(),
        AuthRedirector(
          state: authService,
          guestRedirectPath: '/login',
          userRedirectPath: '/home',
        )
      ],
      refreshNotifiers: [
        /// refresh router when user logged in or logged out
        authService,
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routeInformationParser: router.routeInformationParser,
        routerDelegate: router.routerDelegate,
        routeInformationProvider: router.routeInformationProvider,
      ),
    );

    expect(find.text('Login screen'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.login));
    await tester.pumpAndSettle();

    expect(find.text('Home screen'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.logout));
    await tester.pumpAndSettle();

    expect(find.text('Login screen'), findsOneWidget);
  });
}
