import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listviewblocflutter/data/repository/user_repository_impl.dart';
import 'package:listviewblocflutter/data/service/user_service.dart';
import 'user_event.dart';
import 'user_state.dart';

class UsersBloc extends Bloc<UserEvent, UserState> {
  final UserRepositoryImpl userRepositoryImpl;

  UsersBloc({@required this.userRepositoryImpl});

  @override
  UserState get initialState => UsersInitial();

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    yield UsersLoading();
    if (event is GetAllUsers) {
      try {
        final listOfUsers = await userRepositoryImpl.getAllUsers();
        if (listOfUsers.body.length > 0)
          yield UsersLoaded(listOfUsers.body);
        else
          yield UserListEmpty();
      } catch (_) {
        yield UsersLoadingError("Can't get all users!");
      }
    }
  }
}
