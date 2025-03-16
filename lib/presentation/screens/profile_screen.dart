import 'package:crafted/data/models/post.dart';
import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/presentation/widgets/post_listing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    image: DecorationImage(
                      image: NetworkImage(user!.photoURL!),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user!.displayName!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      user!.email!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(thickness: 0),
          const SizedBox(height: 8),
          StreamBuilder(
            stream: _databaseService.getPostsByEmail(user!.email!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text("You don't have any posts."));
              }

              final List posts = snapshot.data!.docs;

              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                separatorBuilder:
                    (context, index) => const Divider(thickness: 0),
              );
            },
          ),
        ],
      ),
    );
  }
}
