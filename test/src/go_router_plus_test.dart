// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_plus/src/go_router_plus.dart';

import 'auth.dart';
import 'screens.dart';

void main() {
  testWidgets('test go router factory has initial screen will work',
      (tester) async {
    final router = createGoRouter(
      screens: [
        ScreenA(),
        InitialScreenF(),
        ScreenB(),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    expect(find.text('F'), findsOneWidget);
  });

  testWidgets('test go router factory has error screen will work',
      (tester) async {
    final router = createGoRouter(
      screens: [
        InitialScreenF(tapTo: 'H'),
        AwareRedirectScreenH(),
        // H will redirect to screen A but it's not exist screen will cause error.
        ErrorScreenG(),
      ],
      redirectors: [
        ScreenRedirector(),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    final t = find.text('F');

    await tester.tap(t);
    await tester.pumpAndSettle();

    expect(find.text('G'), findsOneWidget);
  });

  test('test go router factory throw exception when received invalid screen',
      () {
    expect(
      () => createGoRouter(
        screens: [
          ScreenA(),
          InvalidBuilderScreen(),
          ScreenB(),
        ],
      ),
      throwsA(isA<InvalidBuilderException>()),
    );
  });

  testWidgets('test go router factory with redirectors', (tester) async {
    for (final tapTo in ['I', 'J', 'H']) {
      /// tapTo i is user screen
      /// j is guest screen
      final router = createGoRouter(
        screens: [
          ScreenA(),
          ScreenIUser(),
          ScreenJGuest(),
          AwareRedirectScreenH(),
          InitialScreenF(tapTo: tapTo),
        ],
        redirectors: [
          ScreenRedirector(),
          AuthRedirector(
            state: tapTo == 'I'
                ? UnLoggedInStateProvider()
                : LoggedInStateProvider(),
            userRedirectPath: '/i',
            guestRedirectPath: '/j',
          ),
        ],
      );

      await tester.pumpWidget(
        MaterialApp.router(
          routerConfig: router,
        ),
      );

      final t = find.text('F');

      await tester.tap(t);
      await tester.pumpAndSettle();

      switch (tapTo) {
        case 'H': // access aware redirect screen will call redirect method of screen.
          expect(find.text('A'), findsOneWidget);
          break;
        case 'I': // access user screen but not logged in will redirect to guest screen.
          expect(find.text('J'), findsOneWidget);
          break;
        case 'J': // access guest screen but logged in will redirect to user screen.
          expect(find.text('I'), findsOneWidget);
          break;
      }
    }
  });

  testWidgets('test shell screen navigator', (tester) async {
    final router = createGoRouter(
      screens: [
        ShellScreenH(),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
      ),
    );

    expect(find.text('Shell screen'), findsOneWidget);

    final t = find.text('F');

    await tester.tap(t);
    await tester.pumpAndSettle();

    expect(find.text('Shell screen'), findsOneWidget);
    expect(find.text('B'), findsOneWidget);
  });
}
