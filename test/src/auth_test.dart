// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plus/src/go_router_plus.dart';
import 'package:mockito/annotations.dart';

import 'auth.dart';
import 'auth_test.mocks.dart';
import 'screens.dart';

@GenerateMocks([GoRouterState])
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

  test('test auth redirector should not redirect screen not implement GuestScreen and UserScreen', () {
    for (final redirector in [userRedirector, guestRedirector]) {
      expect(redirector.shouldRedirect(ScreenA()), false);
      expect(redirector.shouldRedirect(ScreenB()), false);
      expect(
        () => redirector.redirect(ScreenA(), MockGoRouterState()),
        throwsA(isA<UnexpectedScreenException>()),
      );
      expect(
        () => redirector.redirect(ScreenB(), MockGoRouterState()),
        throwsA(isA<UnexpectedScreenException>()),
      );
    }
  });

  test('test auth redirector with un logged state', () {
    expect(guestRedirector.shouldRedirect(ScreenIUser()), true);
    expect(guestRedirector.shouldRedirect(ScreenJGuest()), true);
    expect(guestRedirector.redirect(ScreenIUser(), MockGoRouterState()), '/login');
    expect(guestRedirector.redirect(ScreenJGuest(), MockGoRouterState()), null);
  });

  test('test auth redirector with logged state', () {
    expect(userRedirector.shouldRedirect(ScreenIUser()), true);
    expect(userRedirector.shouldRedirect(ScreenJGuest()), true);
    expect(userRedirector.redirect(ScreenJGuest(), MockGoRouterState()), '/home-page');
    expect(userRedirector.redirect(ScreenIUser(), MockGoRouterState()), null);
  });
}
