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
  })  : _screens = screens,
        _redirector = redirector {
    _routes = _loadScreens();
  }

  Screen? _initialScreen;

  Screen? _errorScreen;

  final List<ScreenBase> _screens;

  /// Route redirector use for setting redirect of [_routes].
  final Redirector? _redirector;

  /// Routes loaded from [_screens] received.
  late final List<RouteBase> _routes;

  List<RouteBase> _loadScreens({List<ScreenBase>? screens}) {
    final routes = <RouteBase>[];

    for (final screen in screens ?? _screens) {
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
  /// The controller of this screen
  late final ScreenController _controller;

  /// List sub screens
  /// all route path of sub screens
  /// will prefix with route path of current screen.
  List<ScreenBase> subScreens() {
    return [];
  }

  /// Route represent for this screen
  RouteBase get _route;
}

/// {@template: go_router_plus.screen.screen}
/// Abstract class extends by app screen.
/// {@endtemplate}
abstract class Screen extends ScreenBase {
  /// {@macro: go_router_plus.screen.screen}
  Screen({GlobalKey<NavigatorState>? parentNavigatorKey})
      : _parentNavigatorKey = parentNavigatorKey;

  /// Go router path
  String get routePath;

  /// Go router name
  String get routeName;

  final GlobalKey<NavigatorState>? _parentNavigatorKey;

  /// An optional key specifying which Navigator to display this screen onto.
  ///
  /// Specifying the root Navigator will stack this route onto that
  /// Navigator instead of the nearest ShellRoute ancestor.
  GlobalKey<NavigatorState>? get parentNavigatorKey => _parentNavigatorKey;

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
        routes: _controller._loadScreens(screens: subScreens()),
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
        routes: _controller._loadScreens(screens: subScreens()),
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

/// {@template go_router_plus.screen.shell_screen}
/// Nested navigation screen base on ShellRoute
/// {@endtemplate}
abstract class ShellScreen extends ScreenBase {
  /// {@macro go_router_plus.screen.shell_screen}
  ShellScreen({GlobalKey<NavigatorState>? navigatorKey})
      : _navigatorKey = navigatorKey ?? GlobalKey<NavigatorState>();

  final GlobalKey<NavigatorState> _navigatorKey;

  /// The [GlobalKey] to be used by the [Navigator] built for this route.
  /// All ShellRoutes build a Navigator by default. Child GoRoutes
  /// are placed onto this Navigator instead of the root Navigator.
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

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
        navigatorKey: navigatorKey,
        routes: _controller._loadScreens(screens: subScreens()),
        pageBuilder: b,
      );
    }

    if (b is Widget Function(BuildContext, GoRouterState, Widget)) {
      return ShellRoute(
        navigatorKey: navigatorKey,
        routes: _controller._loadScreens(screens: subScreens()),
        builder: b,
      );
    }

    throw InvalidBuilderException(this);
  }
}
