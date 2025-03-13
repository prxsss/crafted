import 'package:crafted/presentation/widgets/post_listing.dart';
import 'package:flutter/material.dart';

class PostListingsSeparated extends StatelessWidget {
  const PostListingsSeparated({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      itemBuilder: (context, index) {
        return const PostListing();
      },
      separatorBuilder: (context, index) => const Divider(thickness: 0),
    );
  }
}
