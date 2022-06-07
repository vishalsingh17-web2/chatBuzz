import 'dart:async';

import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/UI/Widgets/chat_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  ConversationTile conversationTile;
  ChatScreen({Key? key, required this.conversationTile}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController message = TextEditingController();
  final ScrollController _controller = ScrollController();
  FirebaseService firebaseService = FirebaseService();
  StreamSubscription? _subscription;

  eventHandler() async {
    var chats = Provider.of<ChatController>(context, listen: false);
    var per = Provider.of<PersonalDetails>(context, listen: false);
    FirebaseService.createMessageCollection(roomId: widget.conversationTile.roomId).then((value) {
      _subscription = firebaseService.getChats(roomId: widget.conversationTile.roomId).listen((event) {
        if (chats.chatData.isEmpty) {
          event.docChanges.forEach((change) {
            if (change.type == DocumentChangeType.added) {
              chats.addChatToList(
                ChatData.fromMap(
                  change.doc.data()!,
                  per.personalDetails.email == change.doc.data()!['sender'],
                ),
              );
            } else if (change.type == DocumentChangeType.removed) {
              chats.deleteMessageLocally(messageId: change.doc.data()!['time']);
            }
          });
        } else {
          event.docChanges.forEach((change) {
            if (change.type == DocumentChangeType.added && per.personalDetails.email != change.doc.data()!['sender'] && change.doc.data()!['sender'] != per.personalDetails.email) {
              chats.addChatToList(
                ChatData.fromMap(
                  change.doc.data()!,
                  false,
                ),
              );
            } else if (change.type == DocumentChangeType.removed && change.doc.data()!['sender'] != per.personalDetails.email) {
              chats.deleteMessageLocally(messageId: change.doc.data()!['time']);
            }
          });
        }
      });
    });
  }

  @override
  void initState() {
    Future.microtask(() async {
      await eventHandler();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _controller.dispose();
        _subscription!.cancel();
        Provider.of<ChatController>(context, listen: false).clearChatData();
        return true;
      },
      child: Consumer2<ChatController, PersonalDetails>(
        builder: (context, chats, pers, child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              title: Text(widget.conversationTile.userDetails.name, style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)),
              leadingWidth: 40,
              leading: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileImage(
                      link: widget.conversationTile.userDetails.profilePicture,
                    ),
                  ),
                ),
                child: Hero(
                  tag: "ProfilePic",
                  child: Container(
                    margin: const EdgeInsets.only(left: 10),
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(
                          widget.conversationTile.userDetails.profilePicture,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            body: GroupedListView<ChatData, String>(
              sort: true,
              order: GroupedListOrder.DESC,
              reverse: true,
              itemComparator: (val1, val2) => val1.time.compareTo(val2.time),
              useStickyGroupSeparators: true,
              floatingHeader: true,
              groupBy: (element) => DateFormat.MMMEd().format(DateTime.parse(element.time)),
              groupSeparatorBuilder: (value) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      margin: const EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        value.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                );
              },
              elements: chats.chatData,
              controller: _controller,
              physics: const BouncingScrollPhysics(),
              indexedItemBuilder: (context, element, index) {
                if (index == 0) {
                  return Column(
                    children: [
                      ChatBox(
                        chatData: element,
                        roomId: widget.conversationTile.roomId,
                      ),
                      const SizedBox(height: 100),
                    ],
                  );
                }
                return ChatBox(
                  chatData: element,
                  roomId: widget.conversationTile.roomId,
                );
              },
            ),
            bottomSheet: TextFormField(
              controller: message,
              maxLines: 2,
              decoration: InputDecoration(
                hintText: 'Type a message',
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
                suffixIcon: IconButton(
                  onPressed: () async {
                    if (message.text.isNotEmpty) {
                      String temp = message.text;
                      message.clear();
                      var chats = Provider.of<ChatController>(context, listen: false);
                      chats.addChatToList(
                        ChatData(
                          sentBy: pers.personalDetails.email,
                          message: temp,
                          time: DateTime.now().toString(),
                          avatarUrl: pers.personalDetails.profilePicture,
                          isMe: true,
                        ),
                      );
                      await chats.sendMessage(
                        message: temp,
                        roomId: widget.conversationTile.roomId,
                        sentBy: pers.personalDetails.email,
                        avatar: pers.personalDetails.profilePicture,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Message cannot be empty'),
                          backgroundColor: Theme.of(context).errorColor,
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.send),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileImage extends StatefulWidget {
  String link;
  ProfileImage({Key? key, required this.link}) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ProfilePic",
      child: Center(
        child: Image.network(
          widget.link,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
