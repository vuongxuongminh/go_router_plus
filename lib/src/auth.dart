// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'go_router_plus.dart';

/// Represent for user state (logged-in system or not).
abstract class LoggedInState {
  /// Getter return true in case user have been logged otherwise is guest.
  bool get loggedIn;
}

/// Redirect user base on [LoggedInState].
class AuthRedirector implements RestrictRedirector {
  /// When user in [UserScreen] but NOT logged in
  /// redirect to [guestRedirectPath].
  /// And when user in [GuestScreen] but logged in
  /// redirect to [userRedirectPath].
  AuthRedirector({
    required this.state,
    required this.guestRedirectPath,
    required this.userRedirectPath,
  });

  /// Guest user will redirect to, this path should be screen
  /// can access by all guest user (ex: login screen).
  final String guestRedirectPath;

  /// User will redirect to, this path should be screen
  /// can access by all guest user (ex: login screen).
  final String userRedirectPath;

  /// User logged-in state
  final LoggedInState state;

  @override
  String? redirect(Screen screen, GoRouterState _) {
    if (!shouldRedirect(screen)) {
      throw UnexpectedScreenException(
        message: 'should implement UserScreen or GuestScreen',
        screen: screen,
      );
    }

    if (screen is UserScreen && !state.loggedIn) {
      return guestRedirectPath;
    }

    if (screen is GuestScreen && state.loggedIn) {
      return userRedirectPath;
    }

    return null;
  }

  @override
  bool shouldRedirect(Screen screen) {
    return screen is UserScreen || screen is GuestScreen;
  }
}

/// Implements by screens for logged-in user [LoggedInState.loggedIn] is true.
abstract class UserScreen {}

/// Implements by screens for guest user (not logged-in)
/// [LoggedInState.loggedIn] is false.
abstract class GuestScreen {}
