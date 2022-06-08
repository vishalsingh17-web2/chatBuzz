import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatData {
  String sentBy;
  String message;
  String time;
  String avatarUrl;
  bool isMe;

  ChatData({required this.sentBy, required this.message, required this.time, required this.avatarUrl, required this.isMe});

  factory ChatData.fromJson(QueryDocumentSnapshot<Object?> json, bool isMe) {
    return ChatData(
      sentBy: json.get('sender'),
      message: json['message'] as String,
      time: json['time'] as String,
      avatarUrl: json['avatar'] as String,
      isMe: isMe,
    );
  }

  factory ChatData.fromMap(Map<String, dynamic> data, bool isMe) {
    return ChatData(
      sentBy: data['sender'],
      message: data['message'] as String,
      time: data['time'] as String,
      avatarUrl: data['avatar'] as String,
      isMe: isMe,
    );
  }
}

class ConversationTile {
  UserDetails userDetails;
  String lastMessage;
  String time;
  String lastMessageSender;
  int unreadCount;
  bool isPinnedChat;
  Map<String, bool> pin;
  String roomId;

  ConversationTile({
    required this.userDetails,
    required this.lastMessage,
    required this.time,
    required this.lastMessageSender,
    required this.unreadCount,
    required this.roomId,
    required this.pin,
    required this.isPinnedChat,
  });

  factory ConversationTile.fromMap(Map<String, dynamic> data) {
    var friendsDetails = data['userDetails'][0]['uid'] == FirebaseAuth.instance.currentUser!.uid ? data['userDetails'][1] : data['userDetails'][0];
    return ConversationTile(
      userDetails: UserDetails.fromMap(friendsDetails),
      lastMessage: data['lastMessage'],
      time: data['lastMessageTime'],
      roomId: data['roomId'],
      lastMessageSender: data['lastMessageSender'],
      unreadCount: data['unreadCount'],
      isPinnedChat: data['isPinned'][FirebaseAuth.instance.currentUser!.email],
      pin: {
        FirebaseAuth.instance.currentUser!.email!: data['isPinned'][FirebaseAuth.instance.currentUser!.email],
        friendsDetails['email']: data['isPinned'][friendsDetails['email']],
      },
    );
  }
}

