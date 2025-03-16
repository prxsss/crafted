import 'dart:math' as math;
import 'package:crafted/data/models/post.dart';
import 'package:crafted/presentation/screens/edit_post_screen.dart';
import 'package:crafted/presentation/screens/post_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:markdown/markdown.dart' as md;

class PostListing extends StatelessWidget {
  const PostListing(
    this.postId,
    this.post, {
    super.key,
    this.showCommentCount = true,
    this.showLikesCount = true,
    this.showContentSample = true,
    this.showAuthor = true,
  });

  final String postId;
  final Post post;

  final bool showCommentCount;
  final bool showLikesCount;
  final bool showContentSample;
  final bool showAuthor;

  String markdownToPlainText(String markdown) {
    final parsed = md.Document().parseLines(markdown.split('\n'));
    final buffer = StringBuffer();

    for (final node in parsed) {
      buffer.writeln(node.textContent);
    }

    return buffer.toString().trim();
  }

  Future<dynamic> _displayDeletePostConfirmationDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          title: Text(
            'Are you sure you want to delete this post?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '"${post.title}"',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              const SizedBox(height: 20),
              Text(
                'Deletion is not reversible, and the post will be completely deleted.',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostDetailScreen(postId, post),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface),
        child: Column(
          children: [
            showAuthor
                ? Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(post.author.photoUrl),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      post.author.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                )
                : const SizedBox.shrink(),
            showAuthor ? const SizedBox(height: 15) : const SizedBox.shrink(),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      showContentSample
                          ? Text(
                            markdownToPlainText(post.content),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 2,
                          )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
                const SizedBox(width: 30),
                Container(
                  width: 80,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    image: DecorationImage(
                      image: NetworkImage(post.imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  DateFormat('MMM dd, yyyy').format(post.updatedAt.toDate()),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 20),
                showLikesCount
                    ? RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Color(0xff6B6B6B)),
                        children: [
                          WidgetSpan(
                            child: FaIcon(
                              FontAwesomeIcons.handsClapping,
                              size: 16,
                              color: Color(0xff6B6B6B),
                            ),
                          ),
                          WidgetSpan(child: SizedBox(width: 5)),
                          TextSpan(text: '158'),
                        ],
                      ),
                    )
                    : const SizedBox.shrink(),
                const SizedBox(width: 20),
                showCommentCount
                    ? RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Color(0xff6B6B6B)),
                        children: [
                          WidgetSpan(
                            child: Transform(
                              alignment: Alignment.center,
                              transform: Matrix4.rotationY(math.pi),
                              child: const FaIcon(
                                FontAwesomeIcons.solidComment,
                                size: 16,
                                color: Color(0xff6B6B6B),
                              ),
                            ),
                          ),
                          const WidgetSpan(child: SizedBox(width: 5)),
                          const TextSpan(text: '10'),
                        ],
                      ),
                    )
                    : const SizedBox.shrink(),
                const Spacer(),
                PopupMenuButton<String>(
                  itemBuilder:
                      (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: const [
                              FaIcon(FontAwesomeIcons.penToSquare),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              FaIcon(FontAwesomeIcons.trash),
                              SizedBox(width: 10),
                              Text('Delete'),
                            ],
                          ),
                        ),
                      ],
                  onSelected: (value) {
                    if (value == 'edit') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditPostScreen(),
                        ),
                      );
                    } else if (value == 'delete') {
                      _displayDeletePostConfirmationDialog(context);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
