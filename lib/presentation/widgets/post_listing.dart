import 'dart:math' as math;
import 'package:crafted/data/models/post.dart';
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
  });

  final String postId;
  final Post post;

  final bool showCommentCount;
  final bool showLikesCount;
  final bool showContentSample;

  String markdownToPlainText(String markdown) {
    final parsed = md.Document().parseLines(markdown.split('\n'));
    final buffer = StringBuffer();

    for (final node in parsed) {
      buffer.writeln(node.textContent);
    }

    return buffer.toString().trim();
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
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                    image: const DecorationImage(
                      image: NetworkImage(
                        'https://avatar.iran.liara.run/public/boy?username=Arunangshu',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Arunangshu Das',
                  style: TextStyle(color: Color(0xff242424)),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.title,
                        style: TextStyle(
                          color: Color(0xff242424),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      showContentSample
                          ? Text(
                            markdownToPlainText(post.content),
                            style: TextStyle(
                              color: Color(0xff6B6B6B),
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
                  style: TextStyle(color: Color(0xff6B6B6B)),
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
              ],
            ),
          ],
        ),
      ),
    );
  }
}
