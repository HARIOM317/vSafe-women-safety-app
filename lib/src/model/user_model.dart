class UserModel {
  String? name;
  String? id;
  String? phone;
  String? email;
  String? type;
  String? profilePic;
  String? about;
  String? createdAt;
  bool? isOnline;
  String? lastActive;
  String? pushToken;

  UserModel({this.name, this.id, this.phone, this.email, this.type, this.profilePic, this.about, this.createdAt, this.isOnline, this.lastActive, this.pushToken});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
      'phone': phone,
      'email': email,
      'type': type,
      'profilePic': profilePic,
      'about': about,
      'created_at': createdAt,
      'is_online': isOnline,
      'last_active': lastActive,
      'push_token': pushToken
    };
  }

  UserModel.fromJson(Map<String, dynamic> json){
    name = json['name'] ?? '';
    phone = json['phone'] ?? '';
    email = json['email'] ?? '';
    type = json['type'] ?? '';
    profilePic = json['profilePic'] ?? '';
    about = json['about'] ?? '';
    createdAt = json['created_at'] ?? '';
    isOnline = json['is_online'];
    lastActive = json['last_active'] ?? '';
    pushToken = json['push_token'] ?? '';
    id = json['id'] ?? '';
  }
}
