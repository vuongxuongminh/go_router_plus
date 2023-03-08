import 'package:go_router_plus/go_router_plus.dart';

class LoggedInStateProvider implements LoggedInState {
  @override
  bool get loggedIn => true;
}

class UnLoggedInStateProvider implements LoggedInState {
  @override
  bool get loggedIn => false;
}
