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

  final Screen _previous;

  final Screen _current;

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
  InvalidBuilderException(this._builder);

  final dynamic Function(BuildContext context, GoRouterState state) _builder;

  @override
  String toString() => '''
    Builder should only return Widget or Page, ${_builder.runtimeType} given
  ''';
}

/// An exception will be throw when receive unexpected screen.
class UnexpectedScreenException implements Exception {
  /// Exception constructor
  UnexpectedScreenException({
    required String message,
    required Screen screen,
  })  : _screen = screen,
        _msg = message;

  final Screen _screen;

  final String _msg;

  @override
  String toString() => '''
    Unexpected screen: ${_screen.runtimeType}, $_msg
  ''';
}
