import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plus/src/exception.dart';
import 'package:go_router_plus/src/redirector.dart';

/// An interface to mark screen as an initial screen (first screen).
abstract class InitialScreen {}

/// An interface to mark screen as an error screen.
abstract class ErrorScreen {}

/// {@template go_router_plus.screen.screen_controller}
/// Collect and analyze list of [ScreenBase] to detect initial screen,
/// error screen and control redirect of routes by using [Redirector].
/// {@endtemplate}
class ScreenController {
  /// {@macro: go_router_plus.screen.screen_controller}
  ScreenController({
    required List<ScreenBase> screens,
    Redirector? redirector,
    GlobalKey<NavigatorState>? navigatorKey,
  })  : _screens = screens,
        _redirector = redirector,
        navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>() {
    _routes = _loadScreens(_screens);
  }

  Screen? _initialScreen;

  Screen? _errorScreen;

  /// Root navigator key of routes
  final GlobalKey<NavigatorState> navigatorKey;

  final List<ScreenBase> _screens;

  final Redirector? _redirector;

  late final List<RouteBase> _routes;

  List<RouteBase> _loadScreens(List<ScreenBase> screens) {
    final routes = <RouteBase>[];

    for (final screen in screens) {
      screen._controller = this;

      if (screen is Screen) {
        _ensureInitialScreenOnLoad(screen);
        _ensureErrorScreenOnLoad(screen);
      }

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
  List<RouteBase> get routes => _routes;
}

/// Screen base defining common logic of screens.
abstract class ScreenBase {
  late final ScreenController _controller;

  /// List sub screens
  /// all route path of sub screens
  /// will prefix with route path of current screen.
  List<ScreenBase> subScreens() {
    return [];
  }

  /// Route represent for this screen
  RouteBase get _route;

  /// Root navigator key, useful for sub screens of shell in cases you want to
  /// set navigator key to to root but not shell.
  GlobalKey<NavigatorState> get rootNavigatorKey => _controller.navigatorKey;
}

/// Abstract class extends by app screens.
abstract class Screen extends ScreenBase {
  /// Go router path
  String get routePath;

  /// Go router name
  String get routeName;

  /// An optional key specifying which Navigator to display this screen onto.
  ///
  /// Specifying the root Navigator will stack this screen onto that
  /// Navigator instead of the nearest [ShellScreen] ancestor.
  ///
  /// Override this getter in case you want to control navigator,
  /// example: sub screens of shell route want to display on root navigator.
  GlobalKey<NavigatorState>? get parentNavigatorKey => null;

  /// Builder help to build widget or page representation for this screen.
  /// when implements this method you must redeclare return type of it,
  /// the return type must be Widget or Page<void>
  /// depends on you want to control transition or not.
  dynamic builder(BuildContext context, GoRouterState state);

  @override
  GoRoute get _route {
    final b = builder;

    if (b is Page<void> Function(BuildContext, GoRouterState)) {
      return GoRoute(
        path: routePath,
        name: routeName,
        routes: _controller._loadScreens(subScreens()),
        redirect: (context, state) => _controller._redirector?.redirect(
          this,
          context,
          state,
        ),
        pageBuilder: b,
        parentNavigatorKey: parentNavigatorKey,
      );
    }

    if (b is Widget Function(BuildContext, GoRouterState)) {
      return GoRoute(
        path: routePath,
        name: routeName,
        routes: _controller._loadScreens(subScreens()),
        redirect: (context, state) => _controller._redirector?.redirect(
          this,
          context,
          state,
        ),
        builder: b,
        parentNavigatorKey: parentNavigatorKey,
      );
    }

    throw InvalidBuilderException(this);
  }
}

/// Nested navigation screen base on ShellRoute
abstract class ShellScreen extends ScreenBase {
  /// The [GlobalKey] to be used by the [Navigator]
  /// built for route of this screen.
  GlobalKey<NavigatorState>? get navigatorKey => null;

  /// The observers for a shell route of this screen.
  ///
  /// The observers parameter is used by the [Navigator] built for this route.
  /// sub-route's observers.
  List<NavigatorObserver>? get observers => null;

  /// Builder help to build widget or page representation for this screen.
  /// when implements this method you must redeclare return type of it,
  /// the return type must be Widget or Page<void>
  /// depends on you want to control transition or not.
  dynamic builder(BuildContext context, GoRouterState state, Widget child);

  @override
  ShellRoute get _route {
    final b = builder;

    if (b is Page<void> Function(BuildContext, GoRouterState, Widget)) {
      return ShellRoute(
        observers: observers,
        navigatorKey: navigatorKey,
        routes: _controller._loadScreens(subScreens()),
        pageBuilder: b,
      );
    }

    if (b is Widget Function(BuildContext, GoRouterState, Widget)) {
      return ShellRoute(
        observers: observers,
        navigatorKey: navigatorKey,
        routes: _controller._loadScreens(subScreens()),
        builder: b,
      );
    }

    throw InvalidBuilderException(this);
  }
}
