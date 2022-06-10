import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();

  List<GroupChatData> chatList = [];
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
      joinedUsers: [currentUser],
      pendingUsers: tile,
      createdBy: currentUser,
      groupName: groupName,
      lastMessage: '',
      lastMessagetime: DateTime.now(),
      lastMessageSender: '',
      roomId: '',
    );
    String id = FirebaseService.createGroupId(
      users: tile + [currentUser],
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

  Future initializeRequestToJoinGroup({required UserDetails personal}) async {
    List<GroupTile> data = await _firebaseService.fetchRequestList(personal: personal);
    requestsList = data;
    notifyListeners();
  }

  Future initializeGroupList({required UserDetails personal}) async {
    groupList = await _firebaseService.fetchGroupList(personal: personal);
    notifyListeners();
  }

  Future joinGroup({required GroupTile tile, required UserDetails personalDetails}) async {
    requestsList.removeWhere((element) => element.roomId == tile.roomId);
    tile.pendingUsers.removeWhere((element) => element.email == FirebaseAuth.instance.currentUser!.email);
    tile.joinedUsers.add(personalDetails);
    groupList.add(tile);
    notifyListeners();
    await _firebaseService.joinGroup(tile: tile, personalDetails: personalDetails);
  }

  Future deleteGroupRequest({required GroupTile tile, required UserDetails personalDetails}) async {
    requestsList.removeWhere((element) => element.roomId == tile.roomId);
    notifyListeners();
    await _firebaseService.deleteGroupRequest(tile: tile, personalDetails: personalDetails);
  }

  sendMessage({required GroupTile tile, required GroupChatData data}) async {
    chatList.add(data);
    notifyListeners();
    await _firebaseService.sendMessageInGroup(tile: tile, message: data);
  }

  addChatToGroup({required GroupChatData data}) {
    chatList.add(data);
    notifyListeners();
  }

  deleteMessageFromGroup({required GroupChatData data}) {
    chatList.removeWhere((element) => element.time == data.time && data.isMe);
    notifyListeners();
  }

  clearChatList() {
    chatList.clear();
    notifyListeners();
  }
}
