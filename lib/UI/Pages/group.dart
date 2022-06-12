import 'package:animations/animations.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:chatbuzz/UI/Pages/create_group.dart';
import 'package:chatbuzz/UI/Pages/group_chat_screen.dart';
import 'package:chatbuzz/UI/Pages/request_list.dart';
import 'package:chatbuzz/UI/Widgets/group_chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Group extends StatefulWidget {
  const Group({Key? key}) : super(key: key);

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Container(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                const Text(
                  "Groups",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  onSelected: (value) => {
                    if (value == "Create Group")
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateGroup(),
                          ),
                        )
                      }
                    else
                      {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RequestList(),
                          ),
                        )
                      }
                  },
                  itemBuilder: (context) {
                    return [
                      const PopupMenuItem(
                        value: "Create Group",
                        child: Text("Create Group"),
                      ),
                      const PopupMenuItem(
                        value: "Create Channel",
                        child: Text("Request list"),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          Consumer<PersonalDetails>(
            builder: (context, pers, child) {
              return Expanded(
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseService.streamGroupList(personal: pers.personalDetails),
                    builder: (context, snapshot) {
                      if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                        return Container();
                      }
                      List<GroupTile> elements = List.from(snapshot.data!.docs).map((e) => GroupTile.fromMap(e.data() as Map<String, dynamic>)).toList();
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: elements.length,
                        itemBuilder: (context, index) {
                          return OpenContainer(
                            transitionType: ContainerTransitionType.fade,
                            middleColor: Theme.of(context).scaffoldBackgroundColor,
                            openColor: Theme.of(context).scaffoldBackgroundColor,
                            closedElevation: 0,
                            closedColor: Theme.of(context).scaffoldBackgroundColor,
                            closedBuilder: ((context, action) {
                              return GroupChatTile(
                                groupTile: elements[index],
                              );
                            }),
                            openBuilder: ((context, action) {
                              return GroupChatScreen(
                                groupTile: elements[index],
                              );
                            }),
                          );
                        },
                      );
                    }),
              );
            },
          ),
        ],
      ),
    );
  }
}
