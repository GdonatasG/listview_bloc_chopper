import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listviewblocflutter/bloc/user/user_bloc_export.dart';
import 'package:listviewblocflutter/data/repository/user_repository_impl.dart';
import 'package:listviewblocflutter/model/built/built_user.dart';
import 'package:built_collection/built_collection.dart';
import 'package:listviewblocflutter/pages/page_user_detail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UsersBloc _userBloc;

  @override
  void initState() {
    _userBloc = UsersBloc(
        userRepositoryImpl: RepositoryProvider.of<UserRepositoryImpl>(context));
    _userBloc.add(GetAllUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: BlocListener<UsersBloc, UserState>(
        bloc: _userBloc,
        listener: (context, state) {
          if (state is UsersLoadingError) {
            _showNetworkErrorSnackbar(context, state.message);
          }
        },
        child: BlocBuilder<UsersBloc, UserState>(
          bloc: _userBloc,
          builder: (context, state) {
            if (state is UsersLoading)
              return _showLoadingStatus();
            else if (state is UsersLoaded)
              return _buildList(state.listOfUsers);
            else if (state is UserListEmpty || state is UsersLoadingError) {
              return _emptyListLayout();
            }
            return Center();
          },
        ),
      ),
    );
  }

  ListView _buildList(BuiltList<BuiltUser> listOfUsers) {
    return ListView.builder(
        itemCount: listOfUsers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => SingleUserPage(
                        userId: listOfUsers[index].id,
                      )));
            },
            child: Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                ),
                title: Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    listOfUsers[index].username,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _showLoadingStatus() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _emptyListLayout() {
    return Center(
      child: Text(
        "List is empty ;(",
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
    _userBloc.close();
    super.dispose();
  }
}
