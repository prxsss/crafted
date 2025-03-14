class User {
  final String email;
  final String name;
  final String photoUrl;

  User({required this.email, required this.name, required this.photoUrl});

  User.fromJson(Map<String, Object?> json)
    : this(
        email: json['email']! as String,
        name: json['name']! as String,
        photoUrl: json['photoUrl']! as String,
      );

  User copyWith({String? name, String? photoUrl}) {
    return User(
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, Object?> toJson() {
    return {'email': email, 'name': name, 'photoUrl': photoUrl};
  }
}
