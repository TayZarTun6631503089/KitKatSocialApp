import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/profile/presentation/components/user_tile.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';

class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;

  const FollowerPage({
    super.key,
    required this.followers,
    required this.following,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: ConstrainedScaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          bottom: TabBar(
            dividerColor: Colors.transparent,

            tabs: [Tab(text: "Followers"), Tab(text: "Following")],
          ),
        ),
        body: TabBarView(
          children: [
            _buildUserList(followers, "No Followers", context),
            _buildUserList(following, "No Following", context),
          ],
        ),
      ),
    );
  }

  // build user List
  Widget _buildUserList(
    List<String> uids,
    String emptyMessage,
    BuildContext context,
  ) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
          itemCount: uids.length,
          itemBuilder: (context, index) {
            final uid = uids[index];
            return FutureBuilder(
              future: context.read<ProfileCubit>().getUserProfile(uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return UserTile(user: user);
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return ListTile(title: Text("Loading..."));
                } else {
                  return ListTile(title: Text("User Not found.."));
                }
              },
            );
          },
        );
  }
}
