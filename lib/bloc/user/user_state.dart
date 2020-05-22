import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:listviewblocflutter/model/built/built_user.dart';
import 'package:built_collection/built_collection.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class UsersInitial extends UserState {
  const UsersInitial();

  @override
  List<Object> get props => [];
}

class UsersLoading extends UserState {
  const UsersLoading();

  @override
  List<Object> get props => [];
}

class UsersLoaded extends UserState {
  final BuiltList<BuiltUser> listOfUsers;

  const UsersLoaded(this.listOfUsers);

  @override
  List<Object> get props => [listOfUsers];
}

class UsersLoadingError extends UserState {
  final String message;

  const UsersLoadingError(this.message);

  @override
  List<Object> get props => [message];
}

class UserListEmpty extends UserState {
  const UserListEmpty();

  @override
  List<Object> get props => [];
}
