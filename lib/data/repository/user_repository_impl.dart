import 'package:built_collection/src/list.dart';
import 'package:chopper/src/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:listviewblocflutter/data/service/user_service.dart';
import 'file:///C:/Users/Donatas/AndroidStudioProjects/listview_bloc_flutter/lib/data/repository/user_repository.dart';
import 'package:listviewblocflutter/model/built/built_user.dart';

class UserRepositoryImpl implements UserRepository {
  final UserService userService;

  UserRepositoryImpl({@required this.userService});

  @override
  Future<Response<BuiltList<BuiltUser>>> getAllUsers() async {
    return await userService.getAllUsers();
  }

  @override
  Future<Response<BuiltUser>> getUserById(int id) async {
    return await userService.getUserById(id);
  }
}
