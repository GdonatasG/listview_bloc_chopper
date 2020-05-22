import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();
}

class GetAllUsers extends UserEvent {
  const GetAllUsers();

  @override
  List<Object> get props => [];
}
