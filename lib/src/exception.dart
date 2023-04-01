import 'package:go_router_plus/src/screen.dart';
import 'package:meta/meta.dart';

/// An exception will be throw in cases
/// screens with the same type providing more than once.
@sealed
class DuplicateScreenException implements Exception {
  /// Two duplicated screens
  DuplicateScreenException(this._previous, this._current, this._type);

  final ScreenBase _previous;

  final ScreenBase _current;

  final Type _type;

  @override
  String toString() => '''
    Duplicated $_type screen: $_previous and $_current
  ''';
}

/// An exception will be throw when classes
/// implementing [Screen] have a [Screen.build] returning invalid types.
@sealed
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
@sealed
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
