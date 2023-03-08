// ignore_for_file: one_member_abstracts

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plus/src/exception.dart';
import 'package:go_router_plus/src/screen.dart';

/// Redirector responsible to redirect end-user to another screen
/// in cases they don't have permission to access the screen
/// or app states are invalid.
abstract class Redirector {
  /// This method will be call before build widget of screen,
  /// return another route path to redirect end-user to another screen or null.
  FutureOr<String?> redirect(
    Screen screen,
    BuildContext buildContext,
    GoRouterState state,
  );
}

/// Redirector can restrict redirect screen
/// depends on result of [shouldRedirect] method.
abstract class RestrictRedirector implements Redirector {
  /// Return true in cases [redirect] method should be call
  /// otherwise shouldn't.
  bool shouldRedirect(Screen screen);
}

/// Chain redirector
class ChainRedirector implements Redirector {
  /// Redirectors have responsibility to decide redirect screen.
  ChainRedirector(this._redirectors);

  final List<Redirector> _redirectors;

  @override
  FutureOr<String?> redirect(
    Screen screen,
    BuildContext context,
    GoRouterState state,
  ) {
    for (final redirector in _redirectors) {
      // ignore: lines_longer_than_80_chars
      if (redirector is RestrictRedirector && !redirector.shouldRedirect(screen)) {
        continue;
      }

      final path = redirector.redirect(screen, context, state);

      if (path != null) {
        return path;
      }
    }

    return null;
  }
}

/// Redirector support screens aware redirect by itself.
class ScreenRedirector implements RestrictRedirector {
  @override
  FutureOr<String?> redirect(
    Screen screen,
    BuildContext context,
    GoRouterState state,
  ) {
    if (!shouldRedirect(screen)) {
      throw UnexpectedScreenException(
        screen: screen,
        message: 'should implement [RedirectAware]',
      );
    }

    return (screen as RedirectAware).redirect(context, state);
  }

  @override
  bool shouldRedirect(Screen screen) {
    return screen is RedirectAware;
  }
}

/// Implements by screens want to control redirect flow by itself.
abstract class RedirectAware {
  /// Return another route path to redirect end-user to another screen or null.
  FutureOr<String?> redirect(BuildContext context, GoRouterState state);
}
