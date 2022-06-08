import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<UserDetails> selectedUsers = [];
  List<GroupTile> groupList = [];
  List<GroupTile> requestsList = [];

  void addSelectedUser(UserDetails user) {
    selectedUsers.every((element) => element.email != user.email) ? selectedUsers.add(user) : null;
    notifyListeners();
  }

  void removeSelectedUser(UserDetails user) {
    selectedUsers.removeWhere((element) => element.email == user.email);
    notifyListeners();
  }

  void clearSelectedUsers() {
    selectedUsers.clear();
    notifyListeners();
  }

  Future<bool> createGroup({required List<UserDetails> tile, required String groupName, required UserDetails currentUser}) async {
    GroupTile data = GroupTile(
      userDetailsList: tile,
      joinedUsers: [currentUser.email],
      pendingUsers: tile.map((e) => e.email).toList(),
      createdBy: currentUser,
      groupName: groupName,
      lastMessage: '',
      lastMessagetime: '',
      lastMessageSender: '',
      roomId: '',
    );
    String id = FirebaseService.createGroupId(
      users: tile.map((e) => e.email).toList() + [currentUser.email],
      groupName: groupName,
    );
    bool check = groupList.every((element) => element.roomId != id);
    if (check) {
      groupList.add(data);
      notifyListeners();
      await FirebaseService.createGroup(tile: data);
      return false;
    } else {
      return true;
    }
  }

  initializeRequestToJoinGroup() async {
    List<GroupTile> data = await  _firebaseService.fetchRequestList();
    requestsList = data;
    notifyListeners();
  }

  initializeGroupList() async {
    groupList = await _firebaseService.fetchGroupList();
    notifyListeners();
  }

  joinGroup({required GroupTile tile}) async {
    requestsList.removeWhere((element) => element.roomId == tile.roomId);
    tile.pendingUsers.removeWhere((element) => element == FirebaseAuth.instance.currentUser!.email);
    tile.joinedUsers.add(FirebaseAuth.instance.currentUser!.email!);
    groupList.add(tile);
    notifyListeners();
    await _firebaseService.joinGroup(tile: tile);
  }

  deleteGroupRequest({required GroupTile tile}) async {
    requestsList.removeWhere((element) => element.roomId == tile.roomId);
    notifyListeners();
    await _firebaseService.deleteGroupRequest(tile: tile);
  }
}
