import 'package:collection/equality.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:listviewblocflutter/bloc/home_page_bloc/user_bloc_export.dart';
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
  final searchQueryController = new TextEditingController();
  String searchQuery;

  // filter options
  BuiltList<BuiltUser> listOfUsers;
  BuiltList<BuiltUser> filteredListOfUsers;
  bool isLoading =
      false; // to disable some actions while loading data (searching, filtering)
  bool isSearchVisible =
      false; // variable to control search view visibility on appBar icon click
  bool isListSearched = false; // searching by text
  bool isListFiltered = false; // filtering by filter options
  bool isRecentlyRefreshed = false; // checking for swipe-refresh
  // Filtering dialog options
  List<String> listOfFilterOptions = [
    'Sort alphabetically',
    'Starts with (A)',
    'Starts with (M)'
  ];

  // Default list -  couldn't be modified!
  List<bool> isFilterOptionModifiedDefault = [false, false, false];

  List<bool> isFilterOptionsModified = [];

  @override
  void initState() {
    // Mounting default filter options list values to exchangeable list
    isFilterOptionsModified = isFilterOptionModifiedDefault.toList();

    _userBloc = UsersBloc(
        userRepositoryImpl: RepositoryProvider.of<UserRepositoryImpl>(context));
    _userBloc.add(GetAllUsers());
    searchQueryController.addListener(_onQueryChangeListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                if (isSearchVisible)
                  isSearchVisible = false;
                else
                  isSearchVisible = true;
              });
            },
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _showFilterDialog();
            },
            icon: Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Column(
        children: [
          isSearchVisible
              ? _searchViewLayout()
              : Container(
                  width: 0,
                  height: 0,
                ),
          BlocListener<UsersBloc, UserState>(
            bloc: _userBloc,
            listener: (context, state) {
              if (state is UsersLoadingError) {
                _showNetworkErrorSnackbar(context, state.message);
              }
            },
            child: BlocBuilder<UsersBloc, UserState>(
              bloc: _userBloc,
              builder: (context, state) {
                if (state is UsersLoading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      isLoading = true;
                    });
                  });
                  return _showLoadingStatus();
                } else {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      isLoading = false;
                    });
                  });
                  if (state is UsersLoaded) {
                    return _checkUsersLoadedLogic(state);
                  } else if (state is UserListEmpty ||
                      state is UsersLoadingError) {
                    return _emptyListLayout();
                  } else
                    return Container();
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _searchViewLayout() {
    return Container(
      color: Theme.of(context).primaryColor,
      child: TextField(
        // !isLoading means enabled when data are not loading
        enabled: !isLoading,
        style: TextStyle(color: Colors.white),
        cursorColor: Colors.white,
        decoration: InputDecoration(
          hintText: 'Search users',
          hintStyle: TextStyle(color: Colors.white),
          suffixIcon: searchQueryController.text.length > 0
              ? IconButton(
                  onPressed: () {
                    searchQueryController.clear();
                    _filterList();
                  },
                  icon: Icon(
                    Icons.cancel,
                    color: Colors.white,
                  ),
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          prefixIcon: Icon(
            Icons.search,
            color: Colors.white,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(20),
        ),
        controller: searchQueryController,
        onChanged: (value) {
          _filterList();
        },
      ),
    );
  }

  _showFilterDialog() {
    showDialog(
        context: context,
        builder: (context) {
          // temporary list to avoid saving "not filtered" options in real list
          List isFilterOptionsModifiedTemp = isFilterOptionsModified.toList();
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Filter'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:
                        List.generate(listOfFilterOptions.length, (index) {
                      return SwitchListTile(
                        title: Text(listOfFilterOptions[index]),
                        value: isFilterOptionsModifiedTemp[index],
                        onChanged: (value) {
                          setState(() {
                            isFilterOptionsModifiedTemp[index] = value;
                          });
                        },
                      );
                    })),
                actions: [
                  FlatButton(
                    child: Text('Remove filter'),
                    onPressed: () {
                      if (isListFiltered && !isLoading) {
                        setState(() {
                          isListFiltered = false;
                          isFilterOptionsModified =
                              isFilterOptionModifiedDefault.toList();
                        });
                        _filterList();
                        Navigator.pop(context);
                      }
                    },
                  ), // Remove filter button
                  FlatButton(
                    child: Text('Filter'),
                    onPressed: () {
                      if (!isLoading) {
                        isFilterOptionsModified =
                            isFilterOptionsModifiedTemp.toList();
                        _filterList();
                        Navigator.pop(context);
                      }
                    },
                  ), // Filter button
                ],
              );
            },
          );
        });
  }

  _checkUsersLoadedLogic(state) {
    if (isListSearched || isListFiltered) {
      if (isRecentlyRefreshed) {
        isRecentlyRefreshed = false;
        listOfUsers = state.listOfUsers;
        _filterList();
        return Container();
      } else
        return _buildList(state.listOfUsers);
    } else {
      listOfUsers = state.listOfUsers;
      return _buildList(state.listOfUsers);
    }
  }

  Widget _buildList(BuiltList<BuiltUser> listOfUsers) {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refreshListOfUsers,
        child: ListView.builder(
            physics: AlwaysScrollableScrollPhysics(),
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
            }),
      ),
    );
  }

  Future<Null> _refreshListOfUsers() async {
    isRecentlyRefreshed = true;
    _userBloc.add(GetAllUsers());

    return null;
  }

  _onQueryChangeListener() {
    setState(() {});
  }

  void _filterList() {
    List<BuiltUser> tempList = [];
    List<BuiltUser> filteredList = listOfUsers.toList();

    // ########################################
    // #******Filtering by Search query*******#
    // ########################################
    String query = searchQueryController.text;
    if (query.isEmpty) {
      isListSearched = false;
      if (!isListFiltered) _userBloc.add(GetAllFilteredUsers(listOfUsers));
    } else {
      isListSearched = true;
      for (BuiltUser u in listOfUsers) {
        if (u.username.toLowerCase().contains(query.toLowerCase())) {
          tempList.add(u);
        }
      }
      filteredList = tempList.toList();
    }

    // ########################################
    // #***Filtering by alertDialog options***#
    // ########################################

    Function eq = const ListEquality().equals;
    // filtering by options will performed only if filter options are not default
    if (!eq(isFilterOptionsModified, isFilterOptionModifiedDefault)) {
      isListFiltered = true;

      // Sort alphabetically option has been switched to true
      if (isFilterOptionsModified[0]) {
        filteredList.sort((a, b) => a.username.compareTo(b.username));
      }
      // Username starts with A option has been switched to true
      if (isFilterOptionsModified[1]) {
        filteredList = filteredList
            .where((e) => e.username.toLowerCase().startsWith("a"))
            .toList();
      }

      // Username starts with M option has been switched to true
      if (isFilterOptionsModified[2]) {
        filteredList = filteredList
            .where((e) => e.username.toLowerCase().startsWith("m"))
            .toList();
      }
    }

    filteredListOfUsers = filteredList.toBuiltList();

    if (isListSearched || isListFiltered) {
      _userBloc.add(GetAllFilteredUsers(filteredListOfUsers));
    }
  }

  _showLoadingStatus() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _emptyListLayout() {
    return Expanded(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "List is empty ;(",
            textAlign: TextAlign.center,
          ),
          OutlineButton(
            child: Text('Refresh'),
            onPressed: () {
              isRecentlyRefreshed = true;
              _userBloc.add(GetAllUsers());
            },
          )
        ],
      )),
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
