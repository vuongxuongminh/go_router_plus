// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router/src/state.dart';
import 'package:go_router_plus/go_router_plus.dart';

class InvalidBuilderScreen extends Screen {
  @override
  void builder(BuildContext context, GoRouterState state) {}

  @override
  String get routeName => 'A';

  @override
  String get routePath => '/a';
}

class ScreenA extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('A');
  }

  @override
  String get routeName => 'A';

  @override
  String get routePath => '/a';
}

class ScreenB extends Screen {
  @override
  Page<void> builder(BuildContext context, GoRouterState state) {
    return NoTransitionPage(child: Text('B'));
  }

  @override
  String get routeName => 'B';

  @override
  String get routePath => '/b';
}

class ScreenC extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('C');
  }

  @override
  String get routeName => 'C';

  @override
  String get routePath => '/c';

  @override
  List<Screen> subScreens() {
    return [
      SubScreenD(),
    ];
  }
}

class SubScreenD extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('D');
  }

  @override
  String get routeName => 'D';

  @override
  String get routePath => 'd';

  @override
  List<Screen> subScreens() {
    return [
      SubScreenE(),
    ];
  }
}

class SubScreenE extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('E');
  }

  @override
  String get routeName => 'E';

  @override
  String get routePath => 'e';
}

class InitialScreenF extends Screen implements InitialScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('E');
  }

  @override
  String get routeName => 'E';

  @override
  String get routePath => 'e';
}

class ErrorScreenG extends Screen implements ErrorScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('E');
  }

  @override
  String get routeName => 'E';

  @override
  String get routePath => 'e';
}
