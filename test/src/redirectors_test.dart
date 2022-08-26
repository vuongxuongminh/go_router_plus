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
import 'package:go_router_plus/go_router_plus.dart';
import 'package:mockito/annotations.dart';

import 'redirectors.dart';
import 'redirectors_test.mocks.dart';
import 'screens.dart';

@GenerateMocks([GoRouterState])
void main() {
  test('test non restrict screen, chain redirector should not redirect', () {
    final redirector = ChainRedirector([
      RedirectorA(),
    ]);

    expect(redirector.redirect(ScreenB(), MockGoRouterState()), null);
  });

  test('test restrict screen, chain redirector should redirect', () {
    final redirector = ChainRedirector([
      RedirectorA(),
    ]);

    expect(redirector.redirect(ScreenA(), MockGoRouterState()), '/b');
  });

  test('test chain redirector always redirect', () {
    final redirector = ChainRedirector([
      RedirectorA(),
      RedirectorB(),
    ]);

    expect(redirector.redirect(ScreenA(), MockGoRouterState()), '/b');
    expect(redirector.redirect(ScreenB(), MockGoRouterState()), '/b');
    expect(redirector.redirect(ScreenC(), MockGoRouterState()), '/b');
  });

  test('test screen rediretor should redirect', () {
    final redirector = ScreenRedirector();

    expect(redirector.redirect(AwareRedirectScreen(), MockGoRouterState()), '/a');
    expect(redirector.shouldRedirect(AwareRedirectScreen()), true);
  });

  test('test screen rediretor should not redirect', () {
    final redirector = ScreenRedirector();

    expect(() => redirector.redirect(ScreenA(), MockGoRouterState()), throwsA(isA<UnexpectedScreenException>()));
    expect(redirector.shouldRedirect(ScreenA()), false);
  });
}
