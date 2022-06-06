import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:flutter/cupertino.dart';

class ChatController extends ChangeNotifier {
  List<ConversationTile> pinnedChats = [
    ConversationTile(
      id: 0,
      isPinnedChat: true,
      name: "Amit",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 0,
    ),
    ConversationTile(
      id: 1,
      isPinnedChat: true,
      name: "Aryan",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 0,
    ),
    ConversationTile(
      id: 2,
      isPinnedChat: true,
      name: "Aratrik",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 0,
    ),
    ConversationTile(
      id: 3,
      isPinnedChat: true,
      name: "Tanishq",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 0,
    ),
    ConversationTile(
        id: 4,
        isPinnedChat: true,
        name: "Aman",
        lastMessage: "Hey, how are you?",
        avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
        time: "12:00",
        unreadCount: 0)
  ];
  List<ConversationTile> recentChats = [
    ConversationTile(
      id: 0,
      isPinnedChat: false,
      name: "Tanmay Singh",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 0,
    ),
    ConversationTile(
      id: 1,
      isPinnedChat: false,
      name: "Tan",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 0,
    ),
    ConversationTile(
      id: 2,
      isPinnedChat: false,
      name: "Aman",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 6,
    ),
    ConversationTile(
      id: 3,
      isPinnedChat: false,
      name: "Aman",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
      time: "12:00",
      unreadCount: 2,
    ),
    ConversationTile(
      id: 4,
      isPinnedChat: false,
      name: "Vishal Singh",
      lastMessage: "Hey, how are you?",
      avatarUrl: "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg",
      time: "12:00",
      unreadCount: 0,
    )
  ];

  void addNewChat(ConversationTile chat) {
    recentChats.add(chat);
    notifyListeners();
  }

  pinChat(ConversationTile chat) {
    ConversationTile temp = chat;
    temp.isPinnedChat = true;
    recentChats.removeWhere((element) => element.id == chat.id);
    pinnedChats.add(temp);
    notifyListeners();
  }

  unpinChat(ConversationTile chat) {
    ConversationTile temp = chat;
    temp.isPinnedChat = false;
    pinnedChats.removeWhere((element) => element.id == chat.id);
    recentChats.add(temp);
    notifyListeners();
  }
}
