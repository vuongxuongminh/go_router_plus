// ignore_for_file: prefer_const_constructors
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_plus/go_router_plus.dart';
import 'package:mockito/annotations.dart';

import 'auth.dart';
import 'auth_test.mocks.dart';
import 'screens.dart';

@GenerateMocks([GoRouterState, BuildContext])
void main() {
  final userRedirector = AuthRedirector(
    state: LoggedInStateProvider(),
    guestRedirectPath: '/login',
    userRedirectPath: '/home-page',
  );
  final guestRedirector = AuthRedirector(
    state: UnLoggedInStateProvider(),
    guestRedirectPath: '/login',
    userRedirectPath: '/home-page',
  );

  test(
      'test auth redirector should not redirect screen not implement GuestScreen and UserScreen',
      () {
    for (final redirector in [userRedirector, guestRedirector]) {
      expect(redirector.shouldRedirect(ScreenA()), false);
      expect(redirector.shouldRedirect(ScreenB()), false);
      expect(
        () => redirector.redirect(
          ScreenA(),
          MockBuildContext(),
          MockGoRouterState(),
        ),
        throwsA(isA<UnexpectedScreenException>()),
      );
      expect(
        () => redirector.redirect(
          ScreenB(),
          MockBuildContext(),
          MockGoRouterState(),
        ),
        throwsA(isA<UnexpectedScreenException>()),
      );
    }
  });

  test('test auth redirector with un logged state', () async {
    expect(guestRedirector.shouldRedirect(ScreenIUser()), true);
    expect(guestRedirector.shouldRedirect(ScreenJGuest()), true);
    expect(
      await guestRedirector.redirect(
        ScreenIUser(),
        MockBuildContext(),
        MockGoRouterState(),
      ),
      '/login',
    );
    expect(
      await guestRedirector.redirect(
        ScreenJGuest(),
        MockBuildContext(),
        MockGoRouterState(),
      ),
      null,
    );
  });

  test('test auth redirector with logged state', () async {
    expect(userRedirector.shouldRedirect(ScreenIUser()), true);
    expect(userRedirector.shouldRedirect(ScreenJGuest()), true);
    expect(
      await userRedirector.redirect(
        ScreenJGuest(),
        MockBuildContext(),
        MockGoRouterState(),
      ),
      '/home-page',
    );
    expect(
      await userRedirector.redirect(
        ScreenIUser(),
        MockBuildContext(),
        MockGoRouterState(),
      ),
      null,
    );
  });
}
