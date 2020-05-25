import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listviewblocflutter/bloc/page_user_detail_bloc/single_user_event.dart';
import 'package:listviewblocflutter/bloc/page_user_detail_bloc/single_user_state.dart';
import 'package:listviewblocflutter/data/repository/user_repository_impl.dart';

class SingleUserBloc extends Bloc<SingleUserEvent, SingleUserState> {
  final UserRepositoryImpl userRepositoryImpl;

  SingleUserBloc({@required this.userRepositoryImpl});

  StreamController<String> _title = StreamController<String>();

  Stream<String> get titleStream => _title.stream;

  updateTitle(String newTitle) {
    _title.sink.add(newTitle);
  }

  @override
  SingleUserState get initialState => UserInitial();

  @override
  Stream<SingleUserState> mapEventToState(SingleUserEvent event) async* {
    yield UserLoading();
    if (event is GetUserById) {
      try {
        final user = await userRepositoryImpl.getUserById(event.id);
        if (user.body != null)
          yield UserLoaded(user.body);
        else
          yield UserEmpty();
      } catch (_) {
        yield UserLoadingError("Can't get user with id ${event.id}!");
      }
    }
  }
}
