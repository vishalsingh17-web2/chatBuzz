import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:flutter/cupertino.dart';

class PersonalDetails extends ChangeNotifier {
  FirebaseService _firebaseService = FirebaseService();

  UserDetails personalDetails = UserDetails(
    name: "Vishal Singh",
    bio: "I am a software developer",
    profilePicture: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
    email: "vishal5657singh5657@gmail.com",
    id: "1",
    phoneNumber: "+91-9888888888",
    status: true,
  );

  updateUserDetails({
    required String name,
    required String bio,
    String? profilePicture,
    String? email,
    String? id,
    String? phoneNumber,
    bool? status,
  }) async {
    UserDetails temp = personalDetails;
    personalDetails = UserDetails(
      name: name,
      bio: bio,
      profilePicture: profilePicture ?? temp.profilePicture,
      email: email ?? temp.email,
      id: id ?? temp.id,
      phoneNumber: phoneNumber ?? temp.phoneNumber,
      status: status ?? temp.status,
    );
    notifyListeners();
    await FirebaseService.updateUserInfo(name: name, bio: bio, photoUrl: profilePicture);
  }

  fetchUserDetails() async{
    personalDetails = await FirebaseService.getUserData();
    notifyListeners();
  }

  
}
