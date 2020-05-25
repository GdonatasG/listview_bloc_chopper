import 'package:equatable/equatable.dart';

abstract class SingleUserEvent extends Equatable {
  const SingleUserEvent();
}

class GetUserById extends SingleUserEvent {
  final int id;

  const GetUserById(this.id);

  @override
  List<Object> get props => [id];
}
