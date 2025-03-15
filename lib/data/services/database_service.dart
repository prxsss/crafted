import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crafted/data/models/post.dart';
import 'package:crafted/data/models/user.dart';

const String POST_COLLECTION_REF = 'posts';
const String USER_COLLECTION_REF = 'users';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _postsRef;
  late final CollectionReference _usersRef;

  DatabaseService() {
    _postsRef = _firestore
        .collection(POST_COLLECTION_REF)
        .withConverter<Post>(
          fromFirestore: (snapshots, _) => Post.fromJson(snapshots.data()!),
          toFirestore: (post, _) => post.toJson(),
        );
    _usersRef = _firestore
        .collection(USER_COLLECTION_REF)
        .withConverter<User>(
          fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!),
          toFirestore: (user, _) => user.toJson(),
        );
  }

  // posts
  Stream<QuerySnapshot> getPosts() {
    return _postsRef.snapshots();
  }

  void addPost(Post post) async {
    await _postsRef.add(post);
  }

  // users
  void createUserInDatabaseWithEmail(auth.User firebaseUser) async {
    await _usersRef
        .doc(firebaseUser.email)
        .set(
          User(
            email: firebaseUser.email!,
            name: firebaseUser.displayName!,
            photoUrl: firebaseUser.photoURL!,
          ),
        )
        .whenComplete(
          () => print(
            'Created user in database with email. Name: ${firebaseUser.displayName} | Email: ${firebaseUser.email} | PhotoUrl: ${firebaseUser.photoURL}',
          ),
        );
  }

  void createUserInDatabaseWithGoogleProvider(auth.User firebaseUser) async {
    await _usersRef
        .doc(firebaseUser.email)
        .set(
          User(
            email: firebaseUser.email!,
            name: firebaseUser.displayName!,
            photoUrl: firebaseUser.photoURL!,
          ),
        )
        .whenComplete(
          () => print(
            'Created user in database with Google Provider. Name: ${firebaseUser.displayName} | Email: ${firebaseUser.email} | PhotoUrl: ${firebaseUser.photoURL}',
          ),
        );
  }
}
