import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/retry.dart';
import 'package:posts_app/features/posts/presentation/pages/post_add_update.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../bloc/posts/posts_bloc.dart';
import '../widgets/posts_page/message_display_widget.dart';
import '../widgets/posts_page/post_list_widget.dart';

class postsPage extends StatelessWidget {
  const postsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingBtn(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('posts'),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is LoadingPostsState) {
            return LoadingWidget();
          } else if (state is LoadedPostsState) {
            return RefreshIndicator(
                onRefresh: () => _onRefresh(context),
                child: PostListWidget(posts: state.posts));
          } else if (state is ErrorPostsState) {
            return MessageDisplayWidget(message: state.message);
          }
          return LoadingWidget();
        },
      ),
    );
  }

  Widget _buildFloatingBtn(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => PostAddUpdatePage(isUpdatePost: false)));
      },
      child: Icon(Icons.add),
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    return BlocProvider.of<PostsBloc>(context).add(RefreshPostEvent());
  }
}
