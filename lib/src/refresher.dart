// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'go_router_plus.dart';

/// The refresher support refresh router by list listenable added.
class Refresher extends ChangeNotifier {
  /// The constructor with notifiers
  /// use to add listener to them to refresh router
  /// when they notify.
  Refresher(List<Listenable> notifiers) {
    for (final notifier in notifiers) {
      notifier.addListener(notifyListeners);
    }
  }
}
