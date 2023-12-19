
import '../../../../../configs/utilities/constants/enums/user_enum.dart';

class UserData {

  final String id;
  final String name;
  final String email;
  final String userType;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.userType
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      userType: json['user_type']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'user_type': userType
    };
  }

  bool isAdmin() {
   return userType == User.admin.name;
  }

  bool isNormalUser() {
    return !isAdmin();
  }
}