import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/Data/models/group_tile.dart';
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
    } catch (e) {
      print(e.toString());
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
    await users.doc(currentUser.email).get().then((value) {
      if (!value.exists) {
        users.doc(currentUser.email).set(userInfo);
      }
    });
  }

  static Future<UserDetails> getUserData() async {
    DocumentSnapshot<Object?> querySnapshot = await users.doc(FirebaseAuth.instance.currentUser!.email).get();
    UserDetails userDetails = UserDetails.fromDocumentSnapshot(querySnapshot);
    return userDetails;
  }

  static Future updateUserInfo({String? name, String? bio, String? photoUrl}) async {
    UserDetails currentUser = await getUserData();
    users.doc(FirebaseAuth.instance.currentUser!.email).update({
      'displayName': name ?? currentUser.name,
      'bio': bio ?? currentUser.bio,
      'photoUrl': photoUrl ?? currentUser.profilePicture,
    });
    FirebaseService firebaseService = FirebaseService();
    List<ConversationTile> list = await firebaseService.fetchMyRooms();
    currentUser.bio = bio ?? currentUser.bio;
    currentUser.name = name ?? currentUser.name;
    currentUser.profilePicture = photoUrl ?? currentUser.profilePicture;
    for (int i = 0; i < list.length; i++) {
      chats.doc(list[i].roomId).update({
        'userDetails': [
          UserDetails.fromUserDetails(list[i].userDetails),
          UserDetails.fromUserDetails(currentUser),
        ]
      });
    }
  }

  // getting list of documents from users collection
  static Future<List<UserDetails>> getUserList() async {
    QuerySnapshot querySnapshot = await users.get();
    List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> data = allData.map((e) => e as Map<String, dynamic>).toList();
    List<UserDetails> userList = [];
    for (int i = 0; i < allData.length; i++) {
      userList.add(UserDetails.fromMap(data[i]));
    }
    return userList;
  }

  static createRoomId({required UserDetails friendsDetail, required UserDetails personalDetails}) {
    List<String> users = [friendsDetail.email, personalDetails.email];
    users.sort();
    String roomId = "${users[0]} _ ${users[1]}";
    return roomId;
  }

  Future createRoom(ConversationTile tile, UserDetails currentUser, String roomId) async {
    var user = auth.currentUser!;
    if (user.email == tile.userDetails.email) {
      return null;
    }
    List<String> authors = [tile.userDetails.email, currentUser.email];
    await chats.doc(roomId).set({
      'isPinned': {tile.userDetails.email: false, currentUser.email: false},
      'userDetails': [
        UserDetails.fromUserDetails(tile.userDetails),
        UserDetails.fromUserDetails(currentUser),
      ],
      'roomId': roomId,
      'users': authors,
      'lastMessage': '',
      'lastMessageTime': DateTime.now(),
      'lastMessageSender': '',
      'unreadCount': 0,
    });
  }

  pinChat({required ConversationTile tile}) async {
    Map<String, bool> isPin = tile.pin;
    isPin[auth.currentUser!.email!] = true;
    await chats.doc(tile.roomId).update({
      'isPinned': isPin,
    });
  }

  unpinChat({required ConversationTile tile}) async {
    Map<String, bool> isPin = tile.pin;
    isPin[auth.currentUser!.email!] = false;
    await chats.doc(tile.roomId).update({
      'isPinned': isPin,
    });
  }

  Future<List<ConversationTile>> fetchMyRooms() async {
    var user = auth.currentUser!;
    QuerySnapshot querySnapshot = await chats.where('users', arrayContains: user.email).get();
    List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> data = allData.map((e) => e as Map<String, dynamic>).toList();
    List<ConversationTile> conversationTiles = [];
    for (int i = 0; i < data.length; i++) {
      conversationTiles.add(
        ConversationTile.fromMap(data[i]),
      );
    }
    return conversationTiles;
  }

  addChat({
    required String roomId,
    required String message,
    required String lastMessageSender,
    required avatarUrl,
    required DateTime date,
  }) async {
    await chats.doc(roomId).update({
      'lastMessage': message,
      'lastMessageTime': date,
      'lastMessageSender': lastMessageSender,
    });
    await chats.doc(roomId).collection('messages').add({
      'message': message,
      'sender': lastMessageSender,
      'time': date,
      'avatar': avatarUrl,
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats({required String roomId}) {
    return chats.doc(roomId).collection('messages').orderBy('time', descending: true).snapshots();
  }

  static List<ChatData> mapDataToChat({required List<QueryDocumentSnapshot<Map<String, dynamic>>> data}) {
    List<ChatData> groupTiles = List.from(data.map((e) => ChatData.fromMap(e.data(), e.data()['sender'] == FirebaseAuth.instance.currentUser!.email)));
    return groupTiles;
  }

  static Future createMessageCollection({required String roomId}) async {
    await chats.doc(roomId).collection('messages').get();
  }

  getChatToShow({required String roomId}) async {
    QuerySnapshot querySnapshot = await chats.doc(roomId).collection('messages').orderBy('time', descending: false).get();
    List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> data = allData.map((e) => e as Map<String, dynamic>).toList();
    List<ChatData> chatData = [];
    data.forEach((element) {
      chatData.add(ChatData.fromMap(element, auth.currentUser!.email == element['sender']));
    });
    return chatData;
  }

  deleteChatRoom({required String roomId}) async {
    await chats.doc(roomId).collection('messages').get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
    await chats.doc(roomId).delete();
  }

  updateRoomInfo({required String roomId, required ConversationTile tile}) async {
    await chats.doc(roomId).update({
      'users': [tile.userDetails.email]
    });
  }

  deleteMessage({required String roomId, required String time}) async {
    await chats.doc(roomId).collection('messages').where('time', isEqualTo: time).get().then((value) {
      value.docs.forEach((element) {
        element.reference.delete();
      });
    });
  }

  // Group Function are defined below
  Future<List<GroupTile>> fetchRequestList({required UserDetails personal}) async {
    QuerySnapshot querySnapshot = await groups.where('pendingUsers', arrayContains: UserDetails.fromUserDetails(personal)).get();
    List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> data = allData.map((e) => e as Map<String, dynamic>).toList();
    List<GroupTile> requests = [];
    for (int i = 0; i < data.length; i++) {
      requests.add(GroupTile.fromMap(data[i]));
    }
    return requests;
  }

  fetchGroupList({required UserDetails personal}) async {
    QuerySnapshot querySnapshot = await groups.where('joinedUsers', arrayContains: UserDetails.fromUserDetails(personal)).get();
    List<Object?> allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    List<Map<String, dynamic>> data = allData.map((e) => e as Map<String, dynamic>).toList();
    List<GroupTile> joinedUsers = [];

    for (int i = 0; i < data.length; i++) {
      joinedUsers.add(GroupTile.fromMap(data[i]));
    }
    return joinedUsers;
  }

  static streamGroupList({required UserDetails personal}) {
    // List<GroupTile> elements = List.from(snapshot.data!.docs).map((e) => GroupTile.fromMap(e.data() as Map<String, dynamic>)).toList();
    return groups.where('joinedUsers', arrayContains: UserDetails.fromUserDetails(personal)).orderBy('lastMessagetime', descending: true).snapshots();
  }

  static createGroupId({required List<UserDetails> users, required String groupName}) {
    List<String> userEmail = [];
    users.forEach((element) {
      userEmail.add(element.email);
    });
    userEmail.sort();
    String roomId = "$groupName-${userEmail.join('_')}";
    return roomId;
  }

  static createGroup({required GroupTile tile}) async {
    String roomId = createGroupId(users: tile.pendingUsers + tile.joinedUsers, groupName: tile.groupName);
    tile.roomId = roomId;
    await groups.doc(roomId).set(GroupTile.fromGroupTile(tile));
  }

  joinGroup({required GroupTile tile, required UserDetails personalDetails}) async {
    await groups.doc(tile.roomId).update({
      'joinedUsers': FieldValue.arrayUnion([UserDetails.fromUserDetails(personalDetails)]),
      'pendingUsers': FieldValue.arrayRemove([UserDetails.fromUserDetails(personalDetails)])
    });
  }

  deleteGroupRequest({required GroupTile tile, required UserDetails personalDetails}) async {
    await groups.doc(tile.roomId).update({
      'pendingUsers': FieldValue.arrayRemove([UserDetails.fromUserDetails(personalDetails)])
    });
  }

  // Group chat function are defined below
  sendMessageInGroup({required GroupTile tile, required GroupChatData message}) async {
    await groups.doc(tile.roomId).update({
      'lastMessage': message.message,
      'lastMessagetime': message.time,
      'lastMessageSender': message.sendersName,
    });
    await groups.doc(tile.roomId).collection('messages').doc(DateTime.now().toString()).set(GroupChatData.fromGroupChatData(message));
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getGroupChats({required String roomId}) {
    return groups.doc(roomId).collection('messages').orderBy('time', descending: true).snapshots().asBroadcastStream();
  }

  getStreamGroupChats({required String roomId}) {
    return groups.doc(roomId).collection('messages').orderBy('time', descending: true).snapshots();
  }

  static List<GroupChatData> mapDataToGroupTile({required List<QueryDocumentSnapshot<Map<String, dynamic>>> data}) {
    List<GroupChatData> groupTiles = List.from(data.map((e) => GroupChatData.fromMap(e.data(), e.data()['senderEmail'] == FirebaseAuth.instance.currentUser!.email)));
    return groupTiles;
  }
}
