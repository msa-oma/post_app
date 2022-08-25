import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import '../../../../core/error/faliures.dart';
import '../entities/post.dart';

class AddPostUsecase {
  final PostsRepository repository;

  AddPostUsecase(this.repository);
  Future<Either<Failure, Unit>> call(Post post) async {
    return await repository.addPost(post);
  }
}
