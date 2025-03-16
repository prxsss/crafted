// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crafted/data/models/post.dart';
import 'package:crafted/data/services/database_service.dart';
import 'package:crafted/main.dart';
import 'package:dio/dio.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditPostScreen extends StatefulWidget {
  final String postId;
  final Post post;

  const EditPostScreen(this.postId, this.post, {super.key});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final DatabaseService _databaseService = DatabaseService();

  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final String _orginalImagePath;

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
        .update(
          postCoverImagePath,
          _selectedImage!,
          fileOptions: FileOptions(cacheControl: '3600', upsert: false),
        );

    final uploadedPostCoverImageUrl = supabase.storage
        .from('images')
        .getPublicUrl(postCoverImagePath);

    return uploadedPostCoverImageUrl;
  }

  Future<void> downloadImage(String url) async {
    try {
      print('url: $url');

      final tempDir = await getTemporaryDirectory();

      // I don't know why, but if I don't set the file path with DateTime the image will be a duplicate of the previous post image.
      final filePath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}/downloaded_image.jpg';

      await Dio().download(url, filePath);

      print('filePath: $filePath');

      setState(() {
        _selectedImage = File(filePath);
        _orginalImagePath = filePath;
      });
    } catch (e) {
      print('Error downloading image: $e');
    }
  }

  Future<void> savePost() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );

    String? uploadedPostCoverImageUrl;

    if (_orginalImagePath != _selectedImage!.path) {
      uploadedPostCoverImageUrl = await uploadImageAndGetUrl(widget.postId);
    }

    Post updatedPost = widget.post.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: Timestamp.now(),
      imageUrl: uploadedPostCoverImageUrl,
    );

    _databaseService.updatePost(widget.postId, updatedPost);

    navigatorKey.currentState!.pop(); // Close the dialog
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _contentController = TextEditingController(text: widget.post.content);
    downloadImage(widget.post.imageUrl);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    if (_selectedImage != null && _selectedImage!.existsSync()) {
      _selectedImage!.delete();
      print('Selected image deleted');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Post'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                await savePost();
                navigatorKey.currentState!
                    .pop(); // close the current screen (CreatePostScreen)
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
            ),
            child: const Text('Save', style: TextStyle(fontSize: 16)),
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
