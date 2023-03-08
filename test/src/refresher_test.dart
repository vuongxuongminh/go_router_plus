// ignore_for_file: prefer_const_constructors
// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router_plus/src/refresher.dart';

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
