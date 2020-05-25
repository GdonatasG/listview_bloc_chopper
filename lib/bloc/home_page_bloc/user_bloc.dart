import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listviewblocflutter/data/repository/user_repository_impl.dart';
import 'user_event.dart';
import 'user_state.dart';

class UsersBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryImpl userRepositoryImpl;

  UsersBloc({@required this.userRepositoryImpl});

  @override
  UserState get initialState => UsersInitial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetAllUsers) {
      yield UsersLoading();
      try {
        final users = await userRepositoryImpl.getAllUsers();
        if (users.body.length > 0)
          yield UsersLoaded(users.body);
        else
          yield UserListEmpty();
      } catch (_) {
        yield UsersLoadingError("Can't get all users!");
      }
    } else if (event is GetAllFilteredUsers) {
      if (event.listOfUsers.isEmpty)
        yield UserListEmpty();
      else {
        yield UsersLoaded(event.listOfUsers);
      }
    }
  }
}
