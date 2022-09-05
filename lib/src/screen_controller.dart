// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'go_router_plus.dart';

/// Collect and analyze list of [Screen] to detect initial screen, error screen
/// and control redirect of routes by using [Redirector].
class ScreenController {
  /// Construct controller with list of [Screen], and [Redirector]
  ScreenController({
    required List<Screen> screens,
    Redirector? redirector,
  })  : _screens = screens,
        _redirector = redirector {
    _routes = _loadScreens();
  }

  Screen? _initialScreen;

  Screen? _errorScreen;

  final List<Screen> _screens;

  /// Route redirector use for setting redirect of [_routes].
  final Redirector? _redirector;

  /// Routes loaded from [_screens] received.
  late final List<GoRoute> _routes;

  List<GoRoute> _loadScreens({List<Screen>? screens}) {
    final routes = <GoRoute>[];

    for (final screen in screens ?? _screens) {
      screen._controller = this;

      _ensureInitialScreenOnLoad(screen);
      _ensureErrorScreenOnLoad(screen);

      routes.add(screen._route);
    }

    return routes;
  }

  void _ensureInitialScreenOnLoad(Screen screen) {
    if (screen is InitialScreen) {
      if (_initialScreen != null) {
        throw DuplicateScreenException(
          _initialScreen!,
          screen,
          InitialScreen,
        );
      }

      _initialScreen = screen;
    }
  }

  void _ensureErrorScreenOnLoad(Screen screen) {
    if (screen is ErrorScreen) {
      if (_errorScreen != null) {
        throw DuplicateScreenException(
          _errorScreen!,
          screen,
          ErrorScreen,
        );
      }

      _errorScreen = screen;
    }
  }

  /// Initial screen usually use for setting initial path of router.
  Screen? get initialScreen => _initialScreen;

  /// Error screen usually use for setting error builder of router.
  Screen? get errorScreen => _errorScreen;

  /// List routes representation for screens
  List<GoRoute> get routes => _routes;
}

/// Abstract class extends by app screen.
abstract class Screen {
  /// The controller of this screen
  late final ScreenController _controller;

  /// Go router path
  String get routePath;

  /// Go router name
  String get routeName;

  /// List sub screens
  /// all route path of sub screens
  /// will prefix with route path of current screen.
  List<Screen> subScreens() {
    return [];
  }

  /// Builder help to build widget or page representation for this screen.
  /// when implements this method you must redeclare return type of it,
  /// the return type must be Widget or Page<void>
  /// depends on you want to control transition or not.
  dynamic builder(BuildContext context, GoRouterState state);

  GoRoute get _route {
    final screenBuilder = builder;
    Page<void> Function(BuildContext, GoRouterState)? pageBuilder;
    Widget Function(BuildContext, GoRouterState)? widgetBuilder;

    if (screenBuilder is Page<void> Function(BuildContext, GoRouterState)) {
      return GoRoute(
        path: routePath,
        name: routeName,
        routes: _controller._loadScreens(screens: subScreens()),
        redirect: (state) => _controller._redirector?.redirect(this, state),
        pageBuilder: screenBuilder,
      );
    }

    if (screenBuilder is Widget Function(BuildContext, GoRouterState)) {
      return GoRoute(
        path: routePath,
        name: routeName,
        routes: _controller._loadScreens(screens: subScreens()),
        redirect: (state) => _controller._redirector?.redirect(this, state),
        builder: screenBuilder,
      );
    }

    throw InvalidBuilderException(this);
  }
}

/// An interface to mark screen as an initial screen (first screen).
abstract class InitialScreen {}

/// An interface to mark screen as an error screen.
abstract class ErrorScreen {}
