import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:listviewblocflutter/model/built/built_user.dart';
part 'serializers.g.dart';

@SerializersFor(const [BuiltUser])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
