import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/main.dart';
import 'package:flutter/cupertino.dart';

class LoginController extends ChangeNotifier {
  FirebaseService firebaseService = FirebaseService();

  bool isLoading = false;

  loginWithGoogle({required BuildContext context}) async {
    isLoading = true;
    notifyListeners();
    firebaseService.signInwithGoogle().then((value) {
      isLoading = false;
      notifyListeners();
      Navigator.pushReplacement(
        context,
        CupertinoPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    });
  }

  logOut() async{
    await firebaseService.signOutFromGoogle();
  }
}
