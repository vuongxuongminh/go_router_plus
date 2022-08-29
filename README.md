Go Router Plus
==============

[Go Router](https://gorouter.dev/) is an awesome easy-to-use and production ready package for creating routes, handling 
navigation, deep and dynamic links but in large apps have a lot of screens, states and auth logics,
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

All of your screens must be extends an abstraction class `Screen` providing by this package. 
The following methods, getters need to implements:

+ Method `builder(BuildContext context, GoRouterState state)` must be redeclare return
type to `Widget` or `Page<void>`, in common case you should use `Widget` but if you want to [control
the transition of screen](https://gorouter.dev/transitions) you should use `Page<void>`.
+ Getter `routeName` declare route name of the screen must be unique.
+ Getter `routePath` declare route path of the screen.

### Mark screen as an initial screen

To setup initial path (the first screen user will see) in traditional way, we will set `initialPath`
argument of `GoRouter` factory but when using this package you need to create the screen implements `InitialScreen` interface instead.

```dart
class LoginScreen extends Screen implements InitialScreen {
  ///......
}
```

### Mark screen as an error screen

As you know, `GoRouter` factory offer we an [errorBuilder](https://gorouter.dev/declarative-routing#error-handling) 
argument to handling error (e.g route not found) but when using this package you need to create the screen implements `ErrorScreen` interface instead.

```dart
class MyErrorScreen extends Screen implements ErrorScreen {
  @override
  Widget builder(BuildContext context, GoRouterState state) {
    return Text(state.error);
  }
  ///......
}
```

### Creating router with screens

Now you got the screen pattern concept, let creating Go Router:

```dart
final router = createGoRouter(
  screens: [
    LoginScreen(),
    MyFirstScreen(),
    MyErrorScreen(),
  ],
);
```

> `createGoRouter` factory function providing by this package.

Redirector
==========

`Redirector` will handles [redirection logics](https://gorouter.dev/redirection) of all routes.

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

To use this builtin feature, you need to create a class implements the `LoggedInState` interface:

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

And you need to marks guest and user screens of you app by using `UserScreen` and `GuestScreen` interfaces:

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

In example above, we have two screen, one for guest (login screen) and one for 
user (home screen). When user is **NOT** logged in he/she will be redirect
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

### Screen redirection

It's a builtin feature to support screens have a custom `redirect` logic (e.g: access control by app states, user roles).

Screens want to build custom redirect logic should be implements `RedirectAware`:

```dart
class VipScreen extends Screen implements UserScreen, RedirectAware {
 @override
 String? redirect(GoRouterState state) {
   /// final currentUser = ....
   return !currentUser.isVip ? '/home' : null; 
 }
}
```

Like [origin redirection](https://gorouter.dev/redirection),
`redirect` method above return null in case current user's VIP type so user can stay 
in this screen, on the other hand normal user will be redirect to home screen.

And to activate this feature pass `ScreenRedirector` instance to `redirectors` argument of factory function:

```dart
final router = createGoRouter(
  screens: [
    LoginScreen(),
    HomeScreen(),
    VipScreen(),
  ],
  redirectors: [
    ScreenRedirector(),
    AuthRedirector(
     state: LoggedInStateProvider(),
     guestRedirectPath: '/login',
     userRedirectPath: '/home',
    ),
  ],
);
```

### Creating custom redirector

In some cases, you may want to control redirection logics for common screens like `AuthRedirector` or `ScreenRedirector` above 
(e.g: add an interface to marks some screens only admin user can access).

```dart
abstract class AdminScreen {}

class ManageUserScreen extends Screen implements AdminScreen {
  ///...
}

class AdminRedirector implements RestrictRedirector {
 @override
 bool shouldRedirect(Screen screen) {
   return screen is AdminScreen;
 }

 @override
 String? redirect(GoRouterState state) {
  /// final currentUser = ....
  return !currentUser.isAdmin ? '/home' : null;
 }
}
```

In the example above, we have add the `AdminScreen` interface use to marks screens for admin user only,
if user's not permit will be redirect to home screen. 

`AdminRedirector` implements `RestrictRedirector` interface only execute `redirect` method when 
`shouldRedirect` method return true otherwise it'll skip. In this case, `shouldRedirect` method
only return `true` when current screen implements `AdminScreen`.

The final step is add custom redirector to `redirectors` argument of factory function

```dart
final router = createGoRouter(
 screens: [
  ManageUserScreen(),
 ],
 redirectors: [
  AdminRedirector(),
  ///...
 ],
);
```

Refresh notifiers
=================

Refresh listenable is a [builtin feature of GoRouter](https://gorouter.dev/redirection#refreshing-with-a-stream) 
to re-invoke redirection logics but it only accept one listenable and we need to implements all of 
re-invoke logics in one place. 

With this package you can add more than one listenable to re-invoke redirection logics so you can separate logics to easy control,
readable and independent to each others.

Pass one or more listenable instance to `refreshNotifiers` argument of factory function:

```dart
class AuthService with ChangeNotifier implements LoggedInState {
  bool _loggedIn = true;
  
  @override
  bool loggedIn() => _loggedIn;
  
  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}

class PromotionService with ChangeNotifer {
 void activate() {
  ///....
  notifyListeners();
 }
}

final authService = AuthService();
final router = createGoRouter(
 screens: [
  ManageUserScreen(),
 ],
 redirectors: [
  AuthRedirector(
   state: authService,
   guestRedirectPath: '/login',
   userRedirectPath: '/home',
  ),
  ///...
 ],
 refreshNotifiers: [
  authService,
  PromotionService(),
  /// GoRouterRefreshStream(...),
 ]
);
```

In the example above, `AuthService` class's a refresh notifier and implements `LoggedInState` interface
to providing state of current user's logged-in or guest. When user logout `AuthRedirector` will invoke 
and redirect he/she to login screen. In the other hand, promotion service will invoke redirection logic
when activate promotion (e.g: move user to promotion screen).

