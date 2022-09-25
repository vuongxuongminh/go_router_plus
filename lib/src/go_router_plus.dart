// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

part 'auth.dart';

part 'screen_controller.dart';

part 'exceptions.dart';

part 'redirectors.dart';

part 'refresher.dart';

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
    screens: screens,
    redirector: ChainRedirector(redirectors ?? []),
  );
  final refresher = Refresher(refreshNotifiers ?? []);
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
