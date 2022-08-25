import 'package:flutter/material.dart';
import '../../domain/entities/post.dart';
import '../widgets/post_detail_page/post_detail_widget.dart';

class PostDetailPage extends StatelessWidget {
  final Post post;
  const PostDetailPage({
    required this.post,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppbar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(title: Text('Post Detail'));
  }

  _buildBody() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: PostDetailWidget(post: post),
      ),
    );
  }
}
