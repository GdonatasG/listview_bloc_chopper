import 'package:listviewblocflutter/model/built/built_user.dart';
import 'package:built_collection/built_collection.dart';

abstract class UserState {
  const UserState();
}

class UsersInitial extends UserState {
  const UsersInitial();

  List<Object> get props => [];
}

class UsersLoading extends UserState {
  const UsersLoading();

  List<Object> get props => [];
}

class UsersLoaded extends UserState {
  final BuiltList<BuiltUser> listOfUsers;

  const UsersLoaded(this.listOfUsers);

  List<Object> get props => [listOfUsers];
}

class UsersLoadingError extends UserState {
  final String message;

  const UsersLoadingError(this.message);

  List<Object> get props => [message];
}

class UserListEmpty extends UserState {
  const UserListEmpty();

  @override
  List<Object> get props => [];
}
