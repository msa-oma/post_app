import 'package:posts_app/core/error/exception.dart';
import 'package:posts_app/core/network/network_info.dart';
import 'package:posts_app/features/posts/data/models/post_model.dart';
import 'package:posts_app/features/posts/domain/entities/post.dart';
import 'package:posts_app/core/error/faliures.dart';
import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import 'package:posts_app/features/posts/domain/usecases/delete_post.dart';
import '../datasources/post_local_data_source.dart';
import '../datasources/post_remote_data_source.dart';

typedef Future<Unit> DeleteOrUpdateOrAddPost();

class PostsRepositryImpl implements PostsRepository {
  final PostRemoteDataSource remoteDataSource;
  final PostLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});
  @override
  Future<Either<Failure, List<Post>>> getAllPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getAllPosts();
        localDataSource.cacheposts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      try {
        final localPost = await localDataSource.getCachedPosts();
        return Right(localPost);
      } on EmptyCacheException {
        return left(EmptyCacheFaliure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPost(Post post) async {
    final PostModel postModel = PostModel(title: post.title, body: post.body);
    return await _getMessage(() {
      return remoteDataSource.addPost(postModel);
    });
  }

  @override
  Future<Either<Failure, Unit>> deletePost(int postId) async {
    return await _getMessage(() {
      return remoteDataSource.deletePost(postId);
    });
  }

  @override
  Future<Either<Failure, Unit>> updatePost(Post post) async {
    final PostModel postModel =
        PostModel(id: post.id, title: post.title, body: post.body);
    return await _getMessage(() {
      return remoteDataSource.updatePost(postModel);
    });
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return left(ServerFailure());
      }
    } else {
      return left(OfflineFaliure());
    }
  }
}
