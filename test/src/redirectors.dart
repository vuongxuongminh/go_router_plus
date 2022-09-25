// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/widgets.dart';
import 'package:go_router/src/state.dart';
import 'package:go_router_plus/go_router_plus.dart';

import 'screens.dart';

class RedirectorA implements RestrictRedirector {
  @override
  String? redirect(Screen screen, BuildContext context, GoRouterState state) {
    return '/b';
  }

  @override
  bool shouldRedirect(Screen screen) {
    return screen is ScreenA;
  }
}

class RedirectorB implements Redirector {
  @override
  String? redirect(Screen screen, BuildContext context, GoRouterState state) {
    return '/b';
  }
}
