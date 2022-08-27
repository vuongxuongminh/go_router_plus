// Copyright (c) 2022, Minh Vuong
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_plus/go_router_plus.dart';

import 'screens.dart';

void main() {
  test('test get routes', () {
    final controller = ScreenController(
      screens: [
        ScreenA(),
        ScreenB(),
        ScreenC(),
      ],
    );

    expect(controller.routes.length, 3);

    expect(controller.routes[0].name, 'A');
    expect(controller.routes[1].name, 'B');
    expect(controller.routes[2].name, 'C');
    expect(controller.routes[2].routes.length, 1);
    expect(controller.routes[2].routes[0].name, 'D');
    expect(controller.routes[2].routes[0].routes.length, 1);
    expect(controller.routes[2].routes[0].routes[0].name, 'E');

    expect(controller.initialScreen, null);
    expect(controller.errorScreen, null);
  });

  test('test constructor will throw exception when have invalid screen builder', () {
    expect(
      () => ScreenController(
        screens: [
          InvalidBuilderScreen(),
        ],
      ),
      throwsA(isA<InvalidBuilderException>()),
    );
  });

  test('test get routes have initial screen', () {
    final screen = InitialScreenF();
    final controller = ScreenController(screens: [screen]);

    expect(controller.routes.length, 1);
    expect(controller.initialScreen, screen);
  });

  test('test get routes have error screen', () {
    final screen = ErrorScreenG();
    final controller = ScreenController(screens: [screen]);

    expect(controller.routes.length, 1);
    expect(controller.errorScreen, screen);
  });
}
