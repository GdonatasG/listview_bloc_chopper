import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listviewblocflutter/bloc/singleUserBloc/single_user_bloc_export.dart';
import 'package:listviewblocflutter/data/repository/user_repository_impl.dart';
import 'package:listviewblocflutter/model/built/built_user.dart';

class SingleUserPage extends StatefulWidget {
  final int userId;

  const SingleUserPage({@required this.userId});

  @override
  _SingleUserPageState createState() => _SingleUserPageState();
}

class _SingleUserPageState extends State<SingleUserPage> {
  SingleUserBloc _singleUserBloc;
  String appBarTitle = "";

  @override
  void initState() {
    _singleUserBloc = SingleUserBloc(
        userRepositoryImpl: RepositoryProvider.of<UserRepositoryImpl>(context));
    _singleUserBloc.add(GetUserById(widget.userId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<Object>(
          stream: _singleUserBloc.titleStream,
          initialData: "",
          builder: (context, snapshot) {
            return Text(snapshot.data);
          },
        ),
      ),
      body: Container(
        child: BlocListener<SingleUserBloc, SingleUserState>(
          bloc: _singleUserBloc,
          listener: (context, state) {
            if (state is UserLoadingError) {
              _showNetworkErrorSnackbar(context, state.message);
            }
          },
          child: BlocBuilder<SingleUserBloc, SingleUserState>(
            bloc: _singleUserBloc,
            builder: (context, state) {
              if (state is UserLoading) {
                return _showLoadingStatus();
              } else if (state is UserLoaded) {
                _singleUserBloc.updateTitle(state.user.username);
                return _generateUserDataBody(state.user);
              } else if (state is UserLoadingError) {
                return _userEmptyLayout();
              }
              return Center();
            },
          ),
        ),
      ),
    );
  }

  Widget _generateUserDataBody(BuiltUser user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Text(user.username)],
      ),
    );
  }

  Widget _showLoadingStatus() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _userEmptyLayout() {
    return Center(
      child: Text(
        "User not found ;(",
        textAlign: TextAlign.center,
      ),
    );
  }

  void _showNetworkErrorSnackbar(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }

  @override
  void dispose() {
    _singleUserBloc.close();
    super.dispose();
  }
}
