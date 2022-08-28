// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:go_router_plus/src/go_router_plus.dart';

class LoggedInStateProvider implements LoggedInState {
  @override
  bool get loggedIn => true;
}

class UnLoggedInStateProvider implements LoggedInState {
  @override
  bool get loggedIn => false;
}
