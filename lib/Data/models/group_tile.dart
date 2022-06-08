import 'package:chatbuzz/Data/models/user_details.dart';

class GroupTile {
  List<UserDetails> userDetailsList;
  List<String> joinedUsers;
  List<String> pendingUsers;
  UserDetails createdBy;
  String groupName;
  String lastMessage;
  String lastMessagetime;
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
      joinedUsers: List.from(data['joinedUsers']),
      createdBy: UserDetails.fromMap(data['createdBy']),
      pendingUsers: List.from(data['pendingUsers']),
      groupName: data['groupName'],
      lastMessage: data['lastMessage'] as String,
      lastMessagetime: data['lastMessagetime'] as String,
      lastMessageSender: data['lastMessageSender'] as String,
      roomId: data['roomId'] as String,
    );
  }

  static fromGroupTile(GroupTile groupTile) {
    return {
      'userDetails': List.from(groupTile.userDetailsList).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'joinedUsers': groupTile.joinedUsers,
      'pendingUsers': groupTile.pendingUsers,
      'createdBy': UserDetails.fromUserDetails(groupTile.createdBy),
      'groupName': groupTile.groupName,
      'lastMessage': groupTile.lastMessage,
      'lastMessagetime': groupTile.lastMessagetime,
      'lastMessageSender': groupTile.lastMessageSender,
      'roomId': groupTile.roomId,
    };
  }
}
