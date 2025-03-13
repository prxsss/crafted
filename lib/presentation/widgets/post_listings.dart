import 'package:crafted/presentation/widgets/post_listing.dart';
import 'package:flutter/material.dart';

class PostListings extends StatelessWidget {
  const PostListings({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return const PostListing(
          showContentSample: false,
          showLikesCount: false,
          showCommentCount: false,
        );
      },
    );
  }
}
