import 'package:dartz/dartz.dart';
import '../entities/post.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import '../../../../core/error/faliures.dart';

class UpdatePostUsecase {
  final PostsRepository repository;

  UpdatePostUsecase(this.repository);
  Future<Either<Failure, Unit>> call(Post post) async {
    return await repository.updatePost(post);
  }
}
