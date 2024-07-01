class UserModel {
  final String userId;
  final String email; // email
  final String nama;
  final String password;

  UserModel({
    required this.userId,
    required this.nama,
    required this.email,
    required this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['user_id'],
      email: json['email'],
      nama: json['nama'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'email': email,
      'nama': nama,
      'password': password,
    };
  }
}
