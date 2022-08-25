// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

// ignore_for_file: prefer_const_constructors
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_plus/go_router_plus.dart';

void main() {
  test('test refresher notify listeners', () {
    final notifierA = ValueNotifier<int>(0);
    final notifierB = ValueNotifier<int>(0);
    final refresher = Refresher([notifierA, notifierB]);
    var counter = 0;

    refresher.addListener(() => counter++);

    notifierA.value++;

    expect(counter, 1);

    notifierB.value++;

    expect(counter, 2);
  });
}
