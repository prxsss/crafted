import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crafted/data/models/post.dart';

const String POST_COLLECTION_REF = 'posts';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _postsRef;

  DatabaseService() {
    _postsRef = _firestore
        .collection(POST_COLLECTION_REF)
        .withConverter<Post>(
          fromFirestore: (snapshots, _) => Post.fromJson(snapshots.data()!),
          toFirestore: (post, _) => post.toJson(),
        );
  }

  Stream<QuerySnapshot> getPosts() {
    return _postsRef.snapshots();
  }

  void addPost(Post post) async {
    await _postsRef.add(post);
  }
}
