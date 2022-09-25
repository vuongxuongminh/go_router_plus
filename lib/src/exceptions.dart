// Copyright (c) 2022, Minh Vuong
// https://github.com/vuongxuongminh
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

part of 'go_router_plus.dart';

/// An exception will be throw in cases
/// screens with the same type providing more than once.
class DuplicateScreenException implements Exception {
  /// Two duplicated screens
  DuplicateScreenException(this._previous, this._current, this._type);

  final ScreenBase _previous;

  final ScreenBase _current;

  final Type _type;

  @override
  String toString() => '''
    Duplicated ${_type.toString()} screen: ${_previous.toString()} and ${_current.toString()}
  ''';
}

/// An exception will be throw when classes
/// implementing [Screen] have a [Screen.builder] returning invalid types.
class InvalidBuilderException implements Exception {
  /// Exception constructor
  InvalidBuilderException(this._screen);

  final ScreenBase _screen;

  @override
  String toString() => '''
    Builder method of [${_screen.runtimeType}] should only return Widget or Page<void>.
  ''';
}

/// An exception will be throw when receive unexpected screen.
class UnexpectedScreenException implements Exception {
  /// Exception constructor
  UnexpectedScreenException({
    required String message,
    required ScreenBase screen,
  })  : _screen = screen,
        _msg = message;

  final ScreenBase _screen;

  final String _msg;

  @override
  String toString() => '''
    Unexpected screen: ${_screen.runtimeType}, $_msg
  ''';
}
