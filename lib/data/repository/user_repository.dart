import 'package:chopper/chopper.dart';
import 'package:listviewblocflutter/model/built/built_user.dart';
import 'package:built_collection/built_collection.dart';

abstract class UserRepository {
  Future<Response<BuiltList<BuiltUser>>> getAllUsers();
  Future<Response<BuiltUser>> getUserById(int id);
}
