import 'package:chatbuzz/Data/models/user_details.dart';

class GroupTile {
  List<UserDetails> userDetailsList;
  List<UserDetails> joinedUsers;
  List<UserDetails> pendingUsers;
  List<UserDetails> adminUsers;
  UserDetails createdBy;
  int count;
  String groupName;
  String lastMessage;
  DateTime lastMessagetime;
  String lastMessageSender;
  String roomId;

  GroupTile({
    required this.count,
    required this.lastMessage,
    required this.userDetailsList,
    required this.pendingUsers,
    required this.createdBy,
    required this.adminUsers,
    required this.joinedUsers,
    required this.groupName,
    required this.lastMessagetime,
    required this.lastMessageSender,
    required this.roomId,
  });

  factory GroupTile.fromMap(Map<String, dynamic> data) {
    return GroupTile(
      count: data['count'] as int,
      userDetailsList: List.from(data['userDetails']).map((e) => UserDetails.fromMap(e)).toList(),
      joinedUsers: List.from(data['joinedUsers']).map((e) => UserDetails.fromMap(e)).toList(),
      adminUsers: List.from(data['adminUsers'] ?? []).map((e) => UserDetails.fromMap(e)).toList(),
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
      'count': groupTile.count,
      'userDetails': List.from(groupTile.userDetailsList).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'joinedUsers': List.from(groupTile.joinedUsers).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'pendingUsers': List.from(groupTile.pendingUsers).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'adminUsers': List.from(groupTile.adminUsers).map((e) => UserDetails.fromUserDetails(e)).toList(),
      'createdBy': UserDetails.fromUserDetails(groupTile.createdBy),
      'groupName': groupTile.groupName,
      'lastMessage': groupTile.lastMessage,
      'lastMessagetime': groupTile.lastMessagetime,
      'lastMessageSender': groupTile.lastMessageSender,
      'roomId': groupTile.roomId,
    };
  }
}
