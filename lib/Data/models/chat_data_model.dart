import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatData {
  int id;
  String sentBy;
  String message;
  DateTime time;
  String avatarUrl;
  bool isMe;

  ChatData({required this.id, required this.sentBy, required this.message, required this.time, required this.avatarUrl, required this.isMe});

  factory ChatData.fromJson(QueryDocumentSnapshot<Object?> json, bool isMe) {
    return ChatData(
      id: json.get('id') as int,
      sentBy: json.get('sender'),
      message: json['message'] as String,
      time: json['time'].toDate(),
      avatarUrl: json['avatar'] as String,
      isMe: isMe,
    );
  }

  factory ChatData.fromMap(Map<String, dynamic> data, bool isMe) {
    return ChatData(
      id: data['id'] as int,
      sentBy: data['sender'],
      message: data['message'] as String,
      time: data['time'].toDate(),
      avatarUrl: data['avatar'] as String,
      isMe: isMe,
    );
  }
}

class ConversationTile {
  int count;
  UserDetails userDetails;
  String lastMessage;
  DateTime time;
  String lastMessageSender;
  int unreadCount;
  bool isPinnedChat;
  Map<String, bool> pin;
  String roomId;

  ConversationTile({
    required this.count,
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
      count: data['count'] as int,
      userDetails: UserDetails.fromMap(friendsDetails),
      lastMessage: data['lastMessage'],
      time: data['lastMessageTime'].toDate(),
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

class GroupChatData {
  int id;
  String sentByEmail;
  String sendersName;
  String message;
  DateTime time;
  String avatarUrl;
  bool isMe;

  GroupChatData({
    required this.id,
    required this.sentByEmail,
    required this.sendersName,
    required this.message,
    required this.time,
    required this.avatarUrl,
    required this.isMe,
  });

  factory GroupChatData.fromJson(QueryDocumentSnapshot<Object?> json, bool isMe) {
    return GroupChatData(
      id: json.get('id') as int,
      sentByEmail: json.get('senderEmail'),
      message: json['message'] as String,
      sendersName: json['sendersName'] as String,
      time: json['time'].toDate(),
      avatarUrl: json['avatar'] as String,
      isMe: isMe,
    );
  }

  factory GroupChatData.fromMap(Map<String, dynamic> data, bool isMe) {
    return GroupChatData(
      id: data['id'] as int,
      sendersName: data['sendersName'],
      sentByEmail: data['senderEmail'],
      message: data['message'] as String,
      time: data['time'].toDate(),
      avatarUrl: data['avatar'] as String,
      isMe: isMe,
    );
  }
  static fromGroupChatData(GroupChatData groupChatData) {
    return {
      'id': groupChatData.id,
      'senderEmail': groupChatData.sentByEmail,
      'message': groupChatData.message,
      'time': groupChatData.time,
      'avatar': groupChatData.avatarUrl,
      'sendersName': groupChatData.sendersName,
    };
  }
}
