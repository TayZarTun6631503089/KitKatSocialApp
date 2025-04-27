import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kitkat_social_app/features/search/domain/repos/search_repo.dart';
import 'package:kitkat_social_app/features/search/presentation/cubit/search_states.dart';

class SearchCubit extends Cubit<SearchStates> {
  final SearchRepo searchRepo;
  SearchCubit({required this.searchRepo}) : super(SearchInitial());

  Future<void> searchUsers(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    try {
      emit(SearchLoading());
      final users = await searchRepo.searchUsers(query);
      emit(SearchLoaded(users));
    } catch (e) {
      emit(SearchError("Failed to search error : $e"));
    }
  }
}
