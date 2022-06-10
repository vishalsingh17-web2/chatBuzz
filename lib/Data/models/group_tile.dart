import 'package:chatbuzz/Data/models/user_details.dart';

class GroupTile {
  List<UserDetails> userDetailsList;
  List<UserDetails> joinedUsers;
  List<UserDetails> pendingUsers;
  UserDetails createdBy;
  String groupName;
  String lastMessage;
  DateTime lastMessagetime;
  String lastMessageSender;
  String roomId;

  GroupTile({
    required this.lastMessage,
    required this.userDetailsList,
    required this.pendingUsers,
    required this.createdBy,
    required this.joinedUsers,
    required this.groupName,
    required this.lastMessagetime,
    required this.lastMessageSender,
    required this.roomId,
  });

  factory GroupTile.fromMap(Map<String, dynamic> data) {
    return GroupTile(
      userDetailsList: List.from(data['userDetails']).map((e) => UserDetails.fromMap(e)).toList(),
      joinedUsers: List.from(data['joinedUsers']).map((e) => UserDetails.fromMap(e)).toList(),
      createdBy: UserDetails.fromMap(data['createdBy']),
      pendingUsers: List.from(data['pendingUsers']).map((e) => UserDetails.fromMap(e)).toList(),
      groupName: data['groupName'],
      lastMessage: data['lastMessage'] as String,
      lastMessagetime: data['lastMessagetime'].toDate(),
      lastMessageSender: data['lastMessageSender'] as String,
      roomId: data['roomId'] as String,
    );
  }

  static fromGroupTile(GroupTile groupTile) {
    return {
      'userDetails': List.from(groupTile.userDetailsList).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'joinedUsers': List.from(groupTile.joinedUsers).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'pendingUsers':List.from(groupTile.pendingUsers).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'createdBy': UserDetails.fromUserDetails(groupTile.createdBy),
      'groupName': groupTile.groupName,
      'lastMessage': groupTile.lastMessage,
      'lastMessagetime': groupTile.lastMessagetime,
      'lastMessageSender': groupTile.lastMessageSender,
      'roomId': groupTile.roomId,
    };
  }
}
