import 'package:crafted/data/models/post.dart';
import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/presentation/widgets/post_listing.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _databaseService.getPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Something went wrong'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: const Text('No posts yet'));
        }

        final List posts = snapshot.data!.docs;

        return ListView.separated(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            String postId = posts[index].id;
            Post post = posts[index].data();
            return PostListing(
              postId,
              post,
              showLikesCount: false,
              showCommentCount: false,
            );
          },
          separatorBuilder: (context, index) => const Divider(thickness: 0),
        );
      },
    );
  }
}
