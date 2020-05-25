import 'package:listviewblocflutter/model/built/built_user.dart';
import 'package:built_collection/built_collection.dart';

abstract class UserEvent {
  const UserEvent();
}

class GetAllUsers extends UserEvent {
  const GetAllUsers();

  List<Object> get props => [];
}

class GetAllFilteredUsers extends UserEvent {
  final BuiltList<BuiltUser> listOfUsers;

  const GetAllFilteredUsers(this.listOfUsers);

  List<Object> get props => [listOfUsers];
}
