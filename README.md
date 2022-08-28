Go Router Plus
==============

[Go Router](https://gorouter.dev/) is an awesome easy-to-use package for creating routes, handling 
navigation, deep and dynamic links but in an application have a lot of screens, states and auth logics,
it's hard to manage routes, redirect and refresh router logics. 

This package try to solve problems above by adding screen pattern, common redirect logics and
 chain redirect/refresh listenable.

Installation
------------

Run the command bellow to install this package:

```bash
flutter pub add go_router_plus
```

After install pub package, now you can import it:

```dart
import 'package:go_router_plus/go_router_plus.dart';
```

Creating screens
----------------
Screen represent for route of your application, the purpose of
it is separate `GoRoute` factory logics out of `GoRouter` factory for
easy-to-read and maintaining.

```dart 
/// lib/screens/my_first_screen.dart

import 'package:go_router_plus/go_router_plus.dart';
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
handling error, it is the screen implementing `ErrorScreen` interface (blank interface) providing by this package.

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

Redirector
==========

`Redirector` is an interface providing by this package implements classes will handles 
[redirection logics](https://gorouter.dev/redirection) of all routes.

You can setup one or many redirectors via `redirectors` argument of `createGoRouter` factory function:

```dart
final router = createGoRouter(
  screens: [
    LoginScreen(),
    MyFirstScreen(),
    MyErrorScreen(),
  ],
  redirectors: [
    AuthRedirector(
     state: LoggedInStateProvider(),
     guestRedirectPath: '/login',
     userRedirectPath: '/home-page',
    ),
    ScreenRedirector(),
  ],
);
```
### Authentication redirection

Authentication redirection is the most of common logic of the whole app 
so it provided out of the box by this package via `AuthRedirector`.

To use this builtin feature, you must to create a class implements the `LoggedInState` interface:

```dart
class LoggedInStateProvider implements LoggedInState {
  bool _loggedIn = false;
  
  @override
  bool get loggedIn => _loggedIn;
  
  set loggedIn(bool value) {
    _loggedIn = value;
  }
}
```

It's a simple interface need you implements `loggedIn` getter,
this getter return `true` when user has been logged in otherwise 
user's guest (not logged in).

And you need to marks guest and user screens via `UserScreen` and `GuestScreen` interfaces:

```dart
class LoginScreen extends Screen implements GuestScreen {
 @override
 String get routePath => '/login';
 ///...
}

class HomeScreen extends Screen implements UserScreen {
 @override
 String get routePath => '/home';
  ///...
}
```

We have two screen, one for guest (login screen) and one for 
user (home screen). When user is NOT logged in he/she will be redirect
to login screen otherwise he/she will redirect to home screen, to handling
this scenario, we need to add `AuthRedirector` with the setting bellow:

```dart
final router = createGoRouter(
  screens: [
    LoginScreen(),
    HomeScreen(),
  ],
  redirectors: [
    AuthRedirector(
     state: LoggedInStateProvider(),
     guestRedirectPath: '/login',
     userRedirectPath: '/home',
    ),
  ],
);
```

Now everytime user access to screens implements `UserScreen` interface but
he/she's **NOT** logged in will be redirect to login screen and if they access to
screens implements `GuestScreen` interface but logged in will be redirect to home screen.
