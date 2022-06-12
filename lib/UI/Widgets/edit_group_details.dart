import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/Controller/group_controller.dart';
import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:chatbuzz/UI/Widgets/selected_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

editGroupDetails({required BuildContext context, required GroupTile tile}) {
  TextEditingController groupName = TextEditingController(text: tile.groupName);
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text("Edit Group"),
        content: TextField(
          decoration: InputDecoration(
            labelText: "Group Name",
            prefixIcon: const Icon(Icons.group),
            border: const OutlineInputBorder(),
            fillColor: Theme.of(context).splashColor.withOpacity(0.6),
          ),
          controller: groupName,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              FirebaseService.changeGroupName(roomId: tile.roomId, groupName: groupName.text).then((value) {
                Navigator.pop(context);
              });
            },
            child: const Text("Save"),
          )
        ],
      );
    },
  );
}

addPersonToGroup({required BuildContext context, required GroupTile tile}) async {
  List<UserDetails> allUserList = List.from(Provider.of<ChatController>(context, listen: false).allChats).map((e) => e.userDetails as UserDetails).toList();
  List<UserDetails> connectedUser = List.from(tile.joinedUsers + tile.pendingUsers).map((e) => e as UserDetails).toList();
  List<UserDetails> differenceUser = allUserList.where((e) => connectedUser.where((e2) => e2.email == e.email).isEmpty).toList();

  return showModalBottomSheet(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    context: (context),
    builder: (context) {
      return Consumer<GroupController>(
        builder: (context, group, state) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 10,
                  width: 60,
                  margin: const EdgeInsets.only(bottom: 40),
                  decoration: BoxDecoration(
                    color: Theme.of(context).splashColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: const Text(
                    "Add Person 🧑‍🦰👧",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),
                group.selectedUsers.isEmpty
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          const Text("Selected members", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: group.selectedUsers.length,
                              itemBuilder: (context, index) {
                                return SelectedTileGroup(user: group.selectedUsers[index]);
                              },
                            ),
                          ),
                        ],
                      ),
                Expanded(
                  child: ListView.builder(
                    itemCount: differenceUser.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        contentPadding: const EdgeInsets.all(0),
                        dense: true,
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(differenceUser[index].profilePicture),
                        ),
                        title: Text(differenceUser[index].name),
                        trailing: IconButton(
                          onPressed: () {
                            group.addSelectedUser(differenceUser[index]);
                          },
                          icon: const Icon(Icons.person_add),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () async {
                    for (var i in group.selectedUsers) {
                      await FirebaseService.addPersonToGroup(roomId: tile.roomId, personal: i);
                    }
                    group.clearSelectedUsers();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.person_add),
                  label: const Text("Add"),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

editMemberPermissions({required BuildContext context, required GroupTile tile, required UserDetails user}) {
  bool isAdmin = false;
  for (var i in tile.adminUsers) {
    if (i.email == user.email) {
      isAdmin = true;
      break;
    }
  }
  checkForPosition() {
    if (tile.createdBy.id == user.id) {
      // "Creator"
      return [
        ListTile(
          dense: true,
          leading: const Icon(Icons.report),
          title: const Text("Report User"),
          onTap: () {
            Navigator.pop(context);
          },
        )
      ];
    }
    // "Member and admins"
    return [
      isAdmin
          ? ListTile(
              dense: true,
              leading: const Icon(Icons.admin_panel_settings_rounded),
              title: const Text("Remove admin permissions"),
              onTap: () async {
                await FirebaseService.removeAdminPermissions(tile: tile, personal: user);
                Navigator.pop(context);
              },
            )
          : ListTile(
              dense: true,
              leading: const Icon(Icons.admin_panel_settings_rounded),
              title: const Text("Make group admin"),
              onTap: () async {
                await FirebaseService.giveAdminPermissions(roomId: tile.roomId, personal: user);
                Navigator.pop(context);
              },
            ),
      ListTile(
        dense: true,
        leading: const Icon(Icons.delete, color: Colors.red),
        title: const Text("Remove from Group", style: TextStyle(color: Colors.red)),
        onTap: () async {
          await FirebaseService.removePersonFromGroup(tile: tile, personal: user);
          Navigator.pop(context);
        },
      ),
      ListTile(
        dense: true,
        leading: const Icon(Icons.report),
        title: const Text("Report User"),
        onTap: () {
          Navigator.pop(context);
        },
      )
    ];
  }

  return showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext con) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          const SizedBox(height: 12),
          Container(
            height: 10,
            width: 60,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ...checkForPosition(),
          const SizedBox(height: 40),
        ],
      );
    },
  );
}

reportUser({required BuildContext context, required GroupTile tile, required UserDetails user}) {
  return showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext con) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          const SizedBox(height: 12),
          Container(
            height: 10,
            width: 60,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.report),
            title: const Text("Report User"),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(height: 40),
        ],
      );
    },
  );
}

removeUserFromPendingList({required BuildContext context, required GroupTile tile, required UserDetails user}) {
  showModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    isScrollControlled: true,
    context: context,
    builder: (BuildContext con) {
      return Wrap(
        alignment: WrapAlignment.center,
        children: [
          const SizedBox(height: 12),
          Container(
            height: 10,
            width: 60,
            margin: const EdgeInsets.only(top: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).splashColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          ListTile(
            dense: true,
            leading: const Icon(Icons.delete, color: Colors.red),
            title: const Text(
              "Delete from pending list",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () async {
              FirebaseService.deleteRequestForUser(personal: user, tile: tile).then((value) {
                Navigator.pop(context);
              });
              
            },
          ),
          const SizedBox(height: 40),
        ],
      );
    },
  );
}
