import 'package:flutter/material.dart';

import 'package:crafted/presentation/widgets/post_listings_separated.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const PostListingsSeparated();
  }
}
