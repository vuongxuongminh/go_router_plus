4.1.1
-----

+ Fix bug chain redirector not wait future.

4.1.0
-----

+ Add `initialExtra` arg to factory to pass extra data alongside initial screen.
+ Change type of `LoggedInState.loggedIn` getter to `FutureOr<bool>`.

4.0.0
-----

+ **BC** change method `builder` of `Screen` and `ShellScreen` to `build`.
+ Use Go Router export types instead redeclare.

3.0.0
-----

+ **BC:** replace method [Screen.parentNavigatorKey()] with [Screen.parentNavigatorKey] getter.
+ **BC:** replace method [ShellScreen.navigatorKey()] with [ShellScreen.navigatorKey] getter.
+ [ShellScreen] add getter observers.
+ Bump version of Go Router version `^6.2.0`.
+ Bump version of `very_good_analysis` to `^4.0.0`.
+ Refactor codebase.
+ Export package `package:go_router/go_router.dart` for dev experience, so we don't need to require both go_router and
  go_router_plus.

2.1.0
-----

+ Add support Go Router 6.

2.0.0
-----

+ Bump Go Router to v5
+ Add **ShellScreen** support nested navigation base on ShellRoute.
+ Refactor code base to be compatible with Go Router v5.

1.0.0
-----
Initial release