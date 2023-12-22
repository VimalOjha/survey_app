
import 'package:json_annotation/json_annotation.dart';
import '../../../../../configs/utilities/constants/enums/user_enum.dart';
part 'user_data.g.dart';

@JsonSerializable(explicitToJson: true)
class UserData {

  final String id;
  final String name;
  final String email;
  @JsonKey(name: 'user_type')
  final String userType;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.userType
  });

  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);

  Map<String, dynamic> toJson() => _$UserDataToJson(this);

  bool isAdmin() {
   return userType == User.admin.name;
  }

  bool isNormalUser() {
    return !isAdmin();
  }
}