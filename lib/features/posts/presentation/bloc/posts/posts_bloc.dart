import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app/core/error/faliures.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/features/posts/domain/usecases/get_all_posts.dart';

import '../../../../../core/strings/failures.dart';
part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetAllPostsUsecase getAllPosts;

  PostsBloc({required this.getAllPosts}) : super(PostsInitial()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts();
        emit(_mapFailureOrPosts(failureOrPosts));
      } else if (event is RefreshPostEvent) {
        emit(LoadingPostsState());
        final failureOrPosts = await getAllPosts();
        emit(_mapFailureOrPosts(failureOrPosts));
      }
    });
  }

  PostsState _mapFailureOrPosts(Either<Failure, List<Post>> either) {
    return either.fold(
      (failure) => ErrorPostsState(message: _mapFailureToMessage(failure)),
      (posts) => LoadedPostsState(
        posts: posts,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFaliure:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFaliure:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error, please try again later .";
    }
  }
}
