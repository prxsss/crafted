import 'package:crafted/data/models/post.dart';
import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/presentation/widgets/post_listing.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              decoration: InputDecoration(hintText: 'Search....'),
            ),
          ),
          const Divider(thickness: 0),
          const SizedBox(height: 10),
          StreamBuilder(
            stream: _databaseService.getPosts(),
            builder: (context, snapshot) {
              List posts = snapshot.data?.docs ?? [];
              if (posts.isEmpty) {
                return const Center(child: Text('No posts yet'));
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  String postId = posts[index].id;
                  Post post = posts[index].data();
                  return PostListing(
                    postId,
                    post,
                    showContentSample: false,
                    showLikesCount: false,
                    showCommentCount: false,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
