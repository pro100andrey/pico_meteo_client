import 'package:async_redux/async_redux.dart';
import 'package:models/user.dart';

import '../../app_state.dart';
import '../models/session_state.dart';

class SetSessionUserAction extends ReduxAction<AppState> {
  SetSessionUserAction({required this.user});

  final User user;

  @override
  AppState reduce() => state.copyWith(
        session: SessionStateAvailable(user: user),
      );
}
