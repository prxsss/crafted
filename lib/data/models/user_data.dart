class UserData {
  final String email;
  final String name;
  final String photoUrl;

  UserData({required this.email, required this.name, required this.photoUrl});

  UserData.fromJson(Map<String, Object?> json)
    : this(
        email: json['email']! as String,
        name: json['name']! as String,
        photoUrl: json['photoUrl']! as String,
      );

  UserData copyWith({String? name, String? photoUrl}) {
    return UserData(
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  Map<String, Object?> toJson() {
    return {'email': email, 'name': name, 'photoUrl': photoUrl};
  }
}
