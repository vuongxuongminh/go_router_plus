import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:go_router_plus/src/redirector.dart';
import 'package:go_router_plus/src/refresher.dart';
import 'package:go_router_plus/src/screen.dart';

/// Factory function to create Go Router
/// with extra logics like [ScreenBase]s,
/// [Redirector]s, and refresh router notifiers.
GoRouter createGoRouter({
  required List<ScreenBase> screens,
  List<Redirector>? redirectors,
  List<Listenable>? refreshNotifiers,
  bool routerNeglect = false,
  int redirectLimit = 8,
  List<NavigatorObserver>? observers,
  bool debugLogDiagnostics = false,
  String? restorationScopeId,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  final controller = ScreenController(
    screens: [...screens],
    redirector: ChainRedirector([...redirectors ?? []]),
  );
  final refresher = Refresher([...refreshNotifiers ?? []]);
  final errorScreenBuilder = controller.errorScreen?.builder;
  Page<void> Function(BuildContext, GoRouterState)? errorPageBuilder;
  Widget Function(BuildContext, GoRouterState)? errorBuilder;

  if (errorScreenBuilder is Page<void> Function(BuildContext, GoRouterState)) {
    errorPageBuilder = errorScreenBuilder;
  }

  if (errorScreenBuilder is Widget Function(BuildContext, GoRouterState)) {
    errorBuilder = errorScreenBuilder;
  }

  return GoRouter(
    routes: controller.routes,
    routerNeglect: routerNeglect,
    redirectLimit: redirectLimit,
    initialLocation: controller.initialScreen?.routePath,
    errorBuilder: errorBuilder,
    errorPageBuilder: errorPageBuilder,
    observers: observers,
    debugLogDiagnostics: debugLogDiagnostics,
    refreshListenable: refresher,
    restorationScopeId: restorationScopeId,
    navigatorKey: navigatorKey,
  );
}
