import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plus/src/exception.dart';
import 'package:go_router_plus/src/redirector.dart';
import 'package:go_router_plus/src/screen.dart';
import 'package:meta/meta.dart';

/// Represent for user state (logged-in system or not).
abstract class LoggedInState {
  /// Getter return true in case user have been logged otherwise is guest.
  FutureOr<bool> get loggedIn;
}

/// Redirect user base on [LoggedInState].
@sealed
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
  FutureOr<String?> redirect(
    Screen screen,
    BuildContext _,
    GoRouterState __,
  ) async {
    if (!shouldRedirect(screen)) {
      throw UnexpectedScreenException(
        message: 'should implement UserScreen or GuestScreen',
        screen: screen,
      );
    }

    final loggedIn = await state.loggedIn;

    if (screen is UserScreen && !loggedIn) {
      return guestRedirectPath;
    }

    if (screen is GuestScreen && loggedIn) {
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
