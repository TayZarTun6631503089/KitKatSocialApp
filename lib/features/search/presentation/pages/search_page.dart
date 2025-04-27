import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/profile/presentation/components/user_tile.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';
import 'package:kitkat_social_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:kitkat_social_app/features/search/presentation/cubit/search_states.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  late final searchCubit = context.read<SearchCubit>();

  void onSearchChanged() {
    final query = searchController.text;
    searchCubit.searchUsers(query);
  }

  @override
  void initState() {
    super.initState();
    searchController.addListener(onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  //Build Ui
  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      appBar: AppBar(
        // search text field
        title: TextField(
          controller: searchController,
          style: TextStyle(color: Colors.white),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            hintText: "Search users...",
            hintStyle: TextStyle(
              color: const Color.fromARGB(255, 227, 226, 226),
            ),
            enabledBorder: InputBorder.none,
          ),
        ),
      ),

      // Search Results
      body: BlocBuilder<SearchCubit, SearchStates>(
        builder: (context, state) {
          if (state is SearchLoaded) {
            if (state.users.isEmpty) {
              return Center(child: Text("No user found"));
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserTile(user: user!);
              },
            );
          }
          //loading
          else if (state is SearchLoading) {
            return Center(child: CircularProgressIndicator());
          }
          //error
          else if (state is SearchError) {
            return Center(child: Text("Search Error : ${state.messages}"));
          }
          // default
          else {
            return Center(child: Text("Start search for Users"));
          }
        },
      ),
    );
  }
}
