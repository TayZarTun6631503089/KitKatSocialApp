import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/auth/data/firebase_auth_repo.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_cubit.dart';
import 'package:kitkat_social_app/features/auth/presentation/cubits/auth_states.dart';
import 'package:kitkat_social_app/features/auth/presentation/pages/auth_page.dart';
import 'package:kitkat_social_app/features/home/presentation/pages/home_page.dart';
import 'package:kitkat_social_app/features/posts/data/firebase_post_repo.dart';
import 'package:kitkat_social_app/features/posts/presentation/cubits/post_cubit.dart';
import 'package:kitkat_social_app/features/profile/data/firebase_profile_repo.dart';
import 'package:kitkat_social_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:kitkat_social_app/features/responsives/constrained_scaffold.dart';
import 'package:kitkat_social_app/features/search/data/firebase_search_repo.dart';
import 'package:kitkat_social_app/features/search/presentation/cubit/search_cubit.dart';
import 'package:kitkat_social_app/features/storage/data/firebase_storage_repo.dart';
import 'package:kitkat_social_app/themes/theme_cubit.dart';

/*

App - Root level

Repository - Database
  - firebase

Bloc Providers: for State Management
  - auth
  - profile
  - post
  - search
  - theme

Check Auth State
  
  - unauthenticated -> auth Page(login/register)
  - authenticated -> home
 */

class MyApp extends StatelessWidget {
  // Auth Repo
  final firebaseAuthRepo = FirebaseAuthRepo();
  final firebaseProfileRepo = FirebaseProfileRepo();
  final firebaseStorageRepo = FirebaseStorageRepo();
  final firebasePostRepo = FirebasePostRepo();
  final firebaseSearchRepo = FirebaseSearchRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // provider cubit to app
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create:
              (context) => AuthCubit(authRepo: firebaseAuthRepo)..checkAuth(),
        ),

        // profile cubit
        BlocProvider<ProfileCubit>(
          create:
              (context) => ProfileCubit(
                profileRepo: firebaseProfileRepo,
                storageRepo: firebaseStorageRepo,
              ),
        ),

        // post cubit
        BlocProvider<PostCubit>(
          create:
              (context) => PostCubit(
                postRepo: firebasePostRepo,
                storageRepo: firebaseStorageRepo,
              ),
        ),
        // search cubit
        BlocProvider<SearchCubit>(
          create: (context) => SearchCubit(searchRepo: firebaseSearchRepo),
        ),
        BlocProvider<ThemeCubit>(create: (create) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeData>(
        builder:
            (context, currentTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: currentTheme,
              home: BlocConsumer<AuthCubit, AuthState>(
                builder: (context, authState) {
                  print(authState);
                  // unauthenticated -> auth Page(login/register)
                  if (authState is Unauthenticated) {
                    return AuthPage();
                  } else if (authState is Authenticated) {
                    return HomePage();
                  } else {
                    return const ConstrainedScaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
                //Listen for error
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
              ),
            ),
      ),
    );
  }
}
