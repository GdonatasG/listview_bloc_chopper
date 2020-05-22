import 'dart:io';

import 'package:chopper/chopper.dart';
import 'package:http/io_client.dart' as http;
import 'package:listviewblocflutter/model/built/built_user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:listviewblocflutter/model/converters/built_value_converter.dart';

part 'user_service.chopper.dart';

@ChopperApi(baseUrl: "/users")
abstract class UserService extends ChopperService {
  @Get()
  Future<Response<BuiltList<BuiltUser>>> getAllUsers();

  @Get(path: "/{id}")
  Future<Response<BuiltUser>> getUserById(@Path("id") int id);

  static UserService create() {
    final client = ChopperClient(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        services: [
          _$UserService(),
        ],
        converter: BuiltValueConverter(),
        interceptors: [HttpLoggingInterceptor()],
        errorConverter: BuiltValueConverter());
    return _$UserService(client);
  }
}
