Go Router Plus
==============

[Go Router](https://gorouter.dev/) is an awesome easy-to-use package for creating routes, handling 
navigation, deep and dynamic links but in an application have a lot of screens, states and auth logics,
it's hard to manage routes, redirect and refresh router logics. 

This package try to solve problems above by adding screen pattern, common redirect logics and
supporting to use chain redirect/refresh listenable.

Installation
------------

Run the command bellow to install this package:

```bash
flutter pub add go_router_plus
```

After install pub package, now you can import it:

```dart
import 'package:go_router_plus/src/go_router_plus.dart';
```

Creating screens
----------------
Screen represent for route of your application, the purpose of
it is separate `GoRoute` factory logics out of `GoRouter` factory for
easy-to-read and maintaining.

```dart 
/// lib/screens/my_first_screen.dart

import 'package:go_router_plus/src/go_router_plus.dart';
import 'package:go_router/go_router.dart'

class MyFirstScreen extends Screen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text('Hello world');
  }

  @override
  String get routeName => 'my_first_screen';

  @override
  String get routePath => '/my-first-screen';
}
```

Abstract class `Screen` providing by this package, all of your screens 
must be extends and implements the following methods, getters:

+ Method `builder(BuildContext context, GoRouterState state)` must be redeclare return
type to `Widget` or `Page<void>`, in common case you should use `Widget` but if you want to [control
the transition of screen](https://gorouter.dev/transitions) you should use `Page<void>`.
+ Getter `routeName` declare route name of the screen must be unique.
+ Getter `routePath` declare route path of the screen.

### Mark screen as an initial screen

To setup initial path (the first screen user will see) in traditional way, we will set `initialPath`
argument of `GoRouter` factory. When using this package initial screen is the screen implementing
`InitialScreen` interface (blank interface).

```dart
class LoginScreen extends Screen implements InitialScreen {
  ///......
}
```

### Mark screen as an error screen

As you know, `GoRouter` factory offer we an [errorBuilder](https://gorouter.dev/declarative-routing#error-handling) 
argument to handling error (e.g route not found). When using this package, you should declare an error screen to 
handling error, it is the screen implementing `ErrorScreen` interface (blank interface) provided by this package.

```dart
class MyErrorScreen extends Screen implements ErrorScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text(state.error);
  }
  ///......
}
```

### Creating router

Now you got screen pattern concept let creating Go Router:

```dart
final router = createGoRouter(
  screens: [
    LoginScreen(),
    MyFirstScreen(),
    MyErrorScreen(),
  ],
);
```

