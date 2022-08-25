// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'go_router_plus.dart';

/// Redirector responsible to redirect end-user to another screen
/// in cases they don't have permission to access the screen
/// or app states are invalid.
abstract class Redirector {
  /// This method will be call before build widget of screen,
  /// return another route path to redirect end-user to another screen or null.
  String? redirect(Screen screen, GoRouterState state);
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
  String? redirect(Screen screen, GoRouterState state) {
    for (final redirector in _redirectors) {
      // ignore: lines_longer_than_80_chars
      if (redirector is RestrictRedirector && !redirector.shouldRedirect(screen)) {
        continue;
      }

      final path = redirector.redirect(screen, state);

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
  String? redirect(Screen screen, GoRouterState state) {
    if (!shouldRedirect(screen)) {
      throw UnexpectedScreenException(
        screen: screen,
        message: 'should implement [RedirectAware]',
      );
    }

    return (screen as RedirectAware).redirect(state);
  }

  @override
  bool shouldRedirect(Screen screen) {
    return Screen is RedirectAware;
  }
}

/// Implements by screens want to control redirect flow by itself.
abstract class RedirectAware {
  /// Return another route path to redirect end-user to another screen or null.
  String? redirect(GoRouterState state);
}
