import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:flutter/cupertino.dart';

class ChatController extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<ConversationTile> pinnedChats = [];
  List<ConversationTile> recentChats = [];
  List<ConversationTile> allChats = [];
  List<ChatData> chatData = [];
  bool isLoading = false;

  Future addNewChat({required UserDetails friendsDetail, required UserDetails personalDetails}) async {
    bool flag = false;
    for (int i = 0; i < recentChats.length; i++) {
      if (recentChats[i].userDetails.email == friendsDetail.email) {
        flag = true;
        break;
      }
    }
    String roomId = FirebaseService.createRoomId(friendsDetail: friendsDetail, personalDetails: personalDetails);
    if (!flag) {
      ConversationTile chat = ConversationTile(
        userDetails: friendsDetail,
        lastMessage: " ",
        time: " ",
        lastMessageSender: " ",
        unreadCount: 0,
        roomId: roomId,
        isPinnedChat: false,
        pin: {friendsDetail.email: false, personalDetails.email: false},
      );
      recentChats.add(chat);
      allChats.add(chat);
      notifyListeners();
      await _firebaseService.createRoom(chat, personalDetails, roomId);
    }
  }

  Future initializeAllChats() async {
    clearAllChats();
    isLoading = true;
    notifyListeners();
    var chats = await _firebaseService.fetchMyRooms();
    for (int i = 0; i < chats.length; i++) {
      if (chats[i].isPinnedChat) {
        pinnedChats.add(chats[i]);
      } else {
        recentChats.add(chats[i]);
      }
      // chatData.add({chats[i].roomId: []});
    }
    isLoading = false;
    allChats = pinnedChats + recentChats;
    notifyListeners();
  }

  clearAllChats() {
    allChats.clear();
    pinnedChats.clear();
    recentChats.clear();
    notifyListeners();
  }

  pinChat(ConversationTile chat) async {
    ConversationTile temp = chat;
    temp.isPinnedChat = true;
    recentChats.removeWhere((element) => element.userDetails.id == chat.userDetails.id);
    pinnedChats.add(temp);
    notifyListeners();
    await _firebaseService.pinChat(tile: chat);
  }

  unpinChat(ConversationTile chat) async {
    ConversationTile temp = chat;
    temp.isPinnedChat = false;
    pinnedChats.removeWhere((element) => element.userDetails.id == chat.userDetails.id);
    recentChats.add(temp);
    notifyListeners();
    await _firebaseService.unpinChat(tile: chat);
  }

  List<UserDetails> usersList = [];
  Future initializeUsersList() async {
    var list = await FirebaseService.getUserList();
    usersList = list;
    notifyListeners();
  }

  List<UserDetails> searchResults = [];
  void searchUser(String searchText) {
    searchResults = usersList.where((element) => element.name.toLowerCase().contains(searchText.toLowerCase())).toList();
    searchResults.removeWhere((element) => element.id == _firebaseService.auth.currentUser!.uid);
    notifyListeners();
  }

  void clearSearchResults() {
    searchResults = [];
    notifyListeners();
  }

  sendMessage({required String message, required String roomId, required String sentBy, required String avatar}) async {
    await _firebaseService.addChat(
      lastMessageSender: sentBy,
      message: message,
      roomId: roomId,
      avatarUrl: avatar,
      date: DateTime.now().toString(),
    );
    clearAllChats();
    initializeAllChats();
  }

  getChats({required String roomId}) async {
    chatData = await _firebaseService.getChatToShow(roomId: roomId);
    notifyListeners();
  }

  void addChatToList(ChatData data) {
    chatData.add(data);
    notifyListeners();
  }

  void clearChatData() {
    chatData.clear();
    notifyListeners();
  }

  void deleteMessage({required String roomId, required String messageId}) async {
    for (int i = 0; i < chatData.length; i++) {
      if (chatData[i].time == messageId) {
        chatData.removeAt(i);
        notifyListeners();
        break;
      }
    }
    await _firebaseService.deleteMessage(roomId: roomId, time: messageId);
    clearAllChats();
    initializeAllChats();
  }

  void deleteMessageLocally({required String messageId}) async {
    for (int i = 0; i < chatData.length; i++) {
      if (chatData[i].time == messageId) {
        chatData.removeAt(i);
        notifyListeners();
        break;
      }
    }
  }

  deleteRoom({required String roomId}) async {
    await _firebaseService.deleteChatRoom(roomId: roomId);
    clearAllChats();
    initializeAllChats();
  }

  deleteChatForMe({required String roomId, required ConversationTile tile}) async {
    isLoading = true;
    notifyListeners();
    await _firebaseService.updateRoomInfo(roomId: roomId, tile: tile);
    isLoading = false;
    clearAllChats();
    initializeAllChats();
  }
}
