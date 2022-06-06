import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails {
  String id;
  String name;
  String bio;
  String profilePicture;
  String email;
  String phoneNumber;
  bool status;
  UserDetails({
    required this.id,
    required this.name,
    required this.bio,
    required this.profilePicture,
    required this.email,
    required this.phoneNumber,
    required this.status,
  });

  factory UserDetails.fromDocumentSnapshot(DocumentSnapshot data) {
    return UserDetails(
      id: data.get('uid'),
      name: data.get('displayName'),
      bio: data.get('bio'),
      profilePicture: data.get('photoUrl'),
      email: data.get('email'),
      phoneNumber: data.get('phoneNumber'),
      status: data.get('status'),
    );
  }

  static Map<String,dynamic> fromUserDetails(UserDetails data) {
    return {
      'uid': data.id,
      'displayName': data.name,
      'bio': data.bio,
      'photoUrl': data.profilePicture,
      'email': data.email,
      'phoneNumber': data.phoneNumber,
      'status': data.status,
    };
  }

  factory UserDetails.fromMap(Map<String, dynamic> data) {
    return UserDetails(
      id: data['uid'],
      name: data['displayName'],
      bio: data['bio'],
      profilePicture: data['photoUrl'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      status: data['status'],
    );
  }
  // 'uid': currentUser.uid.toString(),
  //     'email': currentUser.email.toString(),
  //     'displayName': name ?? currentUser.displayName.toString(),
  //     'photoUrl': photoUrl ?? currentUser.photoURL.toString(),
  //     'phoneNumber': currentUser.phoneNumber.toString(),
  //     'bio': bio ?? '',
  //     'status': true,
}
