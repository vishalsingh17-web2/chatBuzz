import 'package:chatbuzz/Controller/group_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:chatbuzz/UI/Widgets/group_appbar.dart';
import 'package:chatbuzz/UI/Widgets/group_chat_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class GroupChatScreen extends StatefulWidget {
  final GroupTile groupTile;
  const GroupChatScreen({Key? key, required this.groupTile}) : super(key: key);

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final TextEditingController message = TextEditingController();
  // StreamSubscription? _subscription;
  final FirebaseService firebaseService = FirebaseService();
  // eventHandler() async {
  //   var chats = Provider.of<GroupController>(context, listen: false);
  //   var per = Provider.of<PersonalDetails>(context, listen: false);
  //   _subscription = firebaseService.getGroupChats(roomId: widget.groupTile.roomId).listen((event) {
  //     if (chats.chatList.isEmpty) {
  //       event.docChanges.forEach((change) {
  //         if (change.type == DocumentChangeType.added) {
  //           chats.addChatToGroup(
  //             data: GroupChatData.fromMap(
  //               change.doc.data()!,
  //               per.personalDetails.email == change.doc.data()!['senderEmail'],
  //             ),
  //           );
  //         } else if (change.type == DocumentChangeType.removed) {
  //           chats.deleteMessageFromGroup(
  //             data: GroupChatData.fromMap(
  //               change.doc.data()!,
  //               per.personalDetails.email == change.doc.data()!['senderEmail'],
  //             ),
  //           );
  //         }
  //       });
  //     } else {
  //       event.docChanges.forEach((change) {
  //         if (change.type == DocumentChangeType.added && per.personalDetails.email != change.doc.data()!['senderEmail'] && change.doc.data()!['senderEmail'] != per.personalDetails.email) {
  //           chats.addChatToGroup(
  //             data: GroupChatData.fromMap(
  //               change.doc.data()!,
  //               false,
  //             ),
  //           );
  //         } else if (change.type == DocumentChangeType.removed && change.doc.data()!['senderEmail'] != per.personalDetails.email) {
  //           chats.deleteMessageFromGroup(
  //             data: GroupChatData.fromMap(
  //               change.doc.data()!,
  //               per.personalDetails.email == change.doc.data()!['senderEmail'],
  //             ),
  //           );
  //         }
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupController>(
      builder: (context, group, child) {
        return Scaffold(
          appBar: PreferredSize(preferredSize: const Size.fromHeight(0), child: Container()),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              GroupAppBar(inheritedtile: widget.groupTile),
              const Divider(),
              Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: firebaseService.getStreamGroupChats(roomId: widget.groupTile.roomId),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return GroupedListView<GroupChatData, String>(
                        elements: FirebaseService.mapDataToGroupTile(data: snapshot.data!.docs),
                        reverse: true,
                        floatingHeader: true,
                        groupBy: (element) => DateFormat.MMMEd().format(element.time),
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
                        physics: const BouncingScrollPhysics(),
                        indexedItemBuilder: (context, element, index) {
                          if (index == 0) {
                            return Column(
                              children: [
                                GroupChatBox(chatData: element, roomId: widget.groupTile.roomId),
                                const SizedBox(height: 100),
                              ],
                            );
                          }
                          return GroupChatBox(chatData: element, roomId: widget.groupTile.roomId);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            ],
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
                    var group = Provider.of<GroupController>(context, listen: false);
                    var personal = Provider.of<PersonalDetails>(context, listen: false);
                    GroupChatData data = GroupChatData(
                      id:0,
                      message: temp,
                      time: DateTime.now(),
                      avatarUrl: personal.personalDetails.profilePicture,
                      isMe: true,
                      sendersName: personal.personalDetails.name,
                      sentByEmail: personal.personalDetails.email,
                    );
                    await group.sendMessage(tile: widget.groupTile, data: data);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Message cannot be empty'),
                        duration: Duration(seconds: 1),
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
    );
  }
}
