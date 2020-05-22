import 'package:equatable/equatable.dart';
import 'package:listviewblocflutter/model/built/built_user.dart';

abstract class SingleUserState extends Equatable {
  const SingleUserState();
}

class UserInitial extends SingleUserState {
  const UserInitial();

  @override
  List<Object> get props => [];
}

class UserLoading extends SingleUserState {
  const UserLoading();

  @override
  List<Object> get props => [];
}

class UserLoaded extends SingleUserState {
  final BuiltUser user;

  const UserLoaded(this.user);

  @override
  List<Object> get props => [user];
}

class UserLoadingError extends SingleUserState {
  final String message;

  const UserLoadingError(this.message);

  @override
  List<Object> get props => [message];
}

class UserEmpty extends SingleUserState {
  const UserEmpty();

  @override
  List<Object> get props => [];
}
