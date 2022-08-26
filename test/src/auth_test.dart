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
    expect(guestRedirector.shouldRedirect(ScreenOfUser()), true);
    expect(guestRedirector.shouldRedirect(ScreenOfGuest()), true);
    expect(guestRedirector.redirect(ScreenOfUser(), MockGoRouterState()), '/login');
    expect(guestRedirector.redirect(ScreenOfGuest(), MockGoRouterState()), null);
  });

  test('test auth redirector with logged state', () {
    expect(userRedirector.shouldRedirect(ScreenOfUser()), true);
    expect(userRedirector.shouldRedirect(ScreenOfGuest()), true);
    expect(userRedirector.redirect(ScreenOfGuest(), MockGoRouterState()), '/home-page');
    expect(userRedirector.redirect(ScreenOfUser(), MockGoRouterState()), null);
  });
}
