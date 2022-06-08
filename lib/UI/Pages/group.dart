import 'package:chatbuzz/Controller/group_controller.dart';
import 'package:chatbuzz/UI/Pages/create_group.dart';
import 'package:chatbuzz/UI/Pages/request_list.dart';
import 'package:chatbuzz/UI/Widgets/group_chat_tile.dart';
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
    return Consumer<GroupController>(
      builder: (context, groups, child) {
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
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await groups.initializeGroupList();
                  },
                  child: ListView.builder(
                    itemCount: groups.groupList.length,
                    itemBuilder: (context, index) {
                      return GroupChatTile(groupTile: groups.groupList[index]);
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
