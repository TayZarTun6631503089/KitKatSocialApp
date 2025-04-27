import 'package:kitkat_social_app/features/profile/domain/entities/profile_user.dart';

class SearchStates {}

class SearchInitial extends SearchStates {}

class SearchLoading extends SearchStates {}

class SearchLoaded extends SearchStates {
  final List<ProfileUser?> users;
  SearchLoaded(this.users);
}

class SearchError extends SearchStates {
  final String messages;
  SearchError(this.messages);
}
