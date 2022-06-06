import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  static CollectionReference users = FirebaseFirestore.instance.collection('users');
  static CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  static CollectionReference groups = FirebaseFirestore.instance.collection('groups');

  Future signInwithGoogle() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await auth.signInWithCredential(credential);
      await saveUserInfo();
    } on FirebaseAuthException catch (e) {
      print(e.code);
    }
  }

  Future<void> signOutFromGoogle() async {
    await _googleSignIn.signOut();
    await auth.signOut();
  }

  Future saveUserInfo({String? bio, String? name, String? photoUrl}) async {
    final currentUser = auth.currentUser!;
    Map<String, dynamic> userInfo = {
      'uid': currentUser.uid.toString(),
      'email': currentUser.email.toString(),
      'displayName': name ?? currentUser.displayName.toString(),
      'photoUrl': photoUrl ?? currentUser.photoURL.toString(),
      'phoneNumber': currentUser.phoneNumber.toString(),
      'bio': bio ?? '',
      'status': true,
    };
    //
    await users.doc(currentUser.email).get().then((value) {
      if (!value.exists) {
        users.doc(currentUser.email).set(userInfo);
      }
    });

    // SharedData.saveUser(userInfo);
  }

  static Future<UserDetails> getUserData() async {
    DocumentSnapshot<Object?> querySnapshot = await users.doc(FirebaseAuth.instance.currentUser!.email).get();
    UserDetails userDetails = UserDetails.fromDocumentSnapshot(querySnapshot);
    return userDetails;
  }

  static void writeData() {
    // var user =  auth.currentUser!;
    // var email = user.email;
    // users.doc(email).set({
    //   'uid': user.uid,
    //   'email': email,
    //   'photoUrl': user.photoURL,
    //   'displayName': user.displayName,
    //   'phoneNumber': user.phoneNumber,
    //   'fcmToken': Boxes.getFCMToken(),
    // });
  }

  // getting list of documents from users collection
  static getUserList() async {
    // QuerySnapshot querySnapshot = await users.get();
    // List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    // allData = allData.map((e,) => e as Map<String, dynamic>).toList();
    // return allData;
  }
}
