import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// {@template go_router_plus.refresher}
/// The refresher support refresh router by list listenable added.
/// {@endtemplate}
@internal
class Refresher extends ChangeNotifier {
  /// {@macro go_router_plus.refresher}
  Refresher(List<Listenable> notifiers) {
    for (final notifier in notifiers) {
      notifier.addListener(notifyListeners);
    }
  }
}
