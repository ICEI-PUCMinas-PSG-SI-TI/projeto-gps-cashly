class UserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final double income;
  final DateTime? lastActive;

  UserModel({
    required this.uid,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.income = 0.0,
    this.lastActive,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'income': income,
      'lastActive': lastActive?.toIso8601String(),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map, String uid) {
    return UserModel(
      uid: uid,
      email: map['email'] ?? '',
      displayName: map['displayName'],
      photoUrl: map['photoUrl'],
      income: (map['income'] ?? 0).toDouble(),
      lastActive: map['lastActive'] != null ? DateTime.parse(map['lastActive']) : null,
    );
  }
}
