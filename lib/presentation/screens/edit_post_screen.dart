// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crafted/data/models/post.dart';
import 'package:crafted/data/models/user.dart' as crafted;
import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/main.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class EditPostScreen extends StatefulWidget {
  const EditPostScreen({super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();

  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  File? _selectedImage;

  Future _pickImageFromGallery() async {
    final returnedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (returnedImage == null) {
      print('No image selected');
      return;
    }

    setState(() {
      _selectedImage = File(returnedImage.path);
    });
  }

  Future<String> uploadImageAndGetUrl(String postId) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final String postCoverImagePath = 'posts/$postId/cover.jpg';

    await supabase.storage
        .from('images')
        .upload(postCoverImagePath, _selectedImage!);

    final uploadedPostCoverImageUrl = supabase.storage
        .from('images')
        .getPublicUrl(postCoverImagePath);

    return uploadedPostCoverImageUrl;
  }

  Future<void> createPost() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    final auth.User firebaseUser = auth.FirebaseAuth.instance.currentUser!;
    final String postId = Uuid().v4();
    final uploadedPostCoverImageUrl = await uploadImageAndGetUrl(postId);
    final crafted.User author = crafted.User(
      email: firebaseUser.email!,
      name: firebaseUser.displayName!,
      photoUrl: firebaseUser.photoURL!,
    );

    _databaseService.addPost(
      Post(
        title: _titleController.text,
        content: _contentController.text,
        createdAt: Timestamp.now(),
        updatedAt: Timestamp.now(),
        imageUrl: uploadedPostCoverImageUrl,
        author: author,
      ),
    );

    navigatorKey.currentState!.pop(); // Close the dialog
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await createPost();
                navigatorKey.currentState!
                    .pop(); // close the current screen (CreatePostScreen)
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Post', style: TextStyle(fontSize: 16)),
          ),
          const SizedBox(width: 18),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (_selectedImage == null) {
                      _pickImageFromGallery();
                    }
                  },
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: DottedBorder(
                      borderType: BorderType.RRect,
                      dashPattern: [6, 6],
                      color: Theme.of(context).colorScheme.primary,
                      radius: Radius.circular(6),
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child:
                            _selectedImage != null
                                ? Image.file(_selectedImage!)
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.image,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      'Upload a cover image',
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                _selectedImage != null
                    ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _pickImageFromGallery();
                          },
                          style: ElevatedButton.styleFrom(
                            side: BorderSide.none,
                          ),
                          child: const Text('Change'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedImage = null;
                            });
                          },
                          style: TextButton.styleFrom(
                            foregroundColor:
                                Theme.of(context).colorScheme.error,
                          ),
                          child: const Text('Remove'),
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Title',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _titleController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Title can't be blank";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        hintText: 'New post title here...',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Content',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _contentController,
                      minLines: 10,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(16),
                        hintText: 'Write your post content here...',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
