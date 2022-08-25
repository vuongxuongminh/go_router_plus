// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'go_router_plus.dart';

/// Control routes by screens.
class ScreenController {
  /// Construct controller with screens
  ScreenController({
    required List<Screen> screens,
    Redirector? redirector,
  })  : _screens = screens,
        _redirector = redirector;

  Screen? _initialScreen;

  Screen? _errorScreen;

  final List<Screen> _screens;

  /// Route redirector of the controller.
  final Redirector? _redirector;

  /// Loaded routes.
  List<GoRoute>? _routes;

  List<GoRoute> _loadScreens({List<Screen>? screens}) {
    final routes = <GoRoute>[];

    for (final screen in screens ?? _screens) {
      screen.controller = this;

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

  /// First screen
  Screen? get initialScreen => _initialScreen;

  /// Error screen
  Screen? get errorScreen => _errorScreen;

  /// List routes representation for screens
  List<GoRoute> get routes => _routes ??= _loadScreens();
}

/// Abstract class extends by app screen.
abstract class Screen {
  /// The controller of this screen
  late final ScreenController controller;

  /// Go router path
  String get routePath;

  /// Go router name
  String get routeName;

  /// List sub screens
  /// all route path of sub screens will prefix with route path current screen.
  List<Screen> subScreens() {
    return [];
  }

  /// Builder help to build widget or page representation for this screen.
  dynamic builder(BuildContext context, GoRouterState state);

  GoRoute get _route {
    final screenBuilder = builder;
    Page<void> Function(BuildContext, GoRouterState)? pageBuilder;
    Widget Function(BuildContext, GoRouterState)? widgetBuilder;

    if (screenBuilder is Page<void> Function(BuildContext, GoRouterState)) {
      pageBuilder = screenBuilder;
    }

    if (screenBuilder is Widget Function(BuildContext, GoRouterState)) {
      widgetBuilder = screenBuilder;
    }

    if (pageBuilder != null) {
      return GoRoute(
        path: routePath,
        name: routeName,
        routes: controller._loadScreens(screens: subScreens()),
        redirect: (state) => controller._redirector?.redirect(this, state),
        pageBuilder: pageBuilder,
      );
    }

    if (widgetBuilder != null) {
      return GoRoute(
        path: routePath,
        name: routeName,
        routes: controller._loadScreens(screens: subScreens()),
        redirect: (state) => controller._redirector?.redirect(this, state),
        builder: widgetBuilder,
      );
    }

    throw InvalidBuilderException(builder);
  }
}

/// An interface to mark screen as an initial screen (first screen).
abstract class InitialScreen {}

/// An interface to mark screen as an error screen.
abstract class ErrorScreen {}
