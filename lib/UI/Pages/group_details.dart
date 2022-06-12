import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Data/Repository/firebase_helper.dart';
import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:chatbuzz/UI/Widgets/edit_group_details.dart';
import 'package:chatbuzz/UI/Widgets/member_tile.dart';
import 'package:chatbuzz/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class GroupDetails extends StatefulWidget {
  final GroupTile tile;
  const GroupDetails({Key? key, required this.tile}) : super(key: key);

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(0), child: Container()),
      body: Consumer<PersonalDetails>(
        builder: (context, per, state) {
          return StreamBuilder<DocumentSnapshot<Object?>>(
            stream: FirebaseService.streamGroupInfo(roomId: widget.tile.roomId),
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Center(child: LottieBuilder.asset('assets/animations/loading.json'));
              }
              final groupInfo = snapshot.data!.data();
              final GroupTile groupTile = GroupTile.fromMap(groupInfo as Map<String, dynamic>);
              return Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Theme.of(context).splashColor.withOpacity(0.2),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 230,
                                child: Text(
                                  groupTile.groupName,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Text(
                                    'Created by:',
                                    style: TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  CircleAvatar(
                                    radius: 8,
                                    backgroundImage: NetworkImage(groupTile.createdBy.profilePicture),
                                  ),
                                  Text(
                                    groupTile.createdBy.name,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                  const Text("👑")
                                ],
                              ),
                            ],
                          ),
                          const Spacer(),
                          isAdmin(tile: groupTile, user: per.personalDetails)
                              ? IconButton(
                                  onPressed: () async {
                                    editGroupDetails(context: context, tile: groupTile);
                                  },
                                  icon: const Icon(Icons.edit),
                                )
                              : Container(),
                          isAdmin(tile: groupTile, user: per.personalDetails)
                              ? IconButton(
                                  onPressed: () async {
                                    await addPersonToGroup(context: context, tile: groupTile);
                                  },
                                  icon: const Icon(Icons.person_add))
                              : Container(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Text(
                      '🧑🏻‍🤝‍🧑🏼 Members  (${groupTile.joinedUsers.length})',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: groupTile.joinedUsers.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 8, right: 12),
                                  child: InkWell(
                                    onLongPress: () async {
                                      if (isAdmin(tile: groupTile, user: per.personalDetails) && groupTile.joinedUsers[index].id != per.personalDetails.id) {
                                        await editMemberPermissions(
                                          context: context,
                                          tile: groupTile,
                                          user: groupTile.joinedUsers[index],
                                        );
                                      } else if (groupTile.joinedUsers[index].id != per.personalDetails.id) {
                                        reportUser(
                                          context: context,
                                          tile: groupTile,
                                          user: groupTile.joinedUsers[index],
                                        );
                                      }
                                    },
                                    child: MemberTile(
                                      tile: groupTile.joinedUsers[index],
                                      position: checkForPosition(
                                        tile: groupTile,
                                        user: groupTile.joinedUsers[index],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    groupTile.pendingUsers.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Requested users (${groupTile.pendingUsers.length})',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: 150,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        physics: const BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: groupTile.pendingUsers.length,
                                        itemBuilder: (context, index) {
                                          return Container(
                                            margin: const EdgeInsets.only(top: 8, right: 12),
                                            child: InkWell(
                                              onLongPress: () async {
                                                await removeUserFromPendingList(context: context, tile: groupTile, user: groupTile.pendingUsers[index]);
                                              },
                                              child: MemberTile(
                                                tile: groupTile.pendingUsers[index],
                                                position: "Pending",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Divider()
                            ],
                          )
                        : Container(),
                    ListTile(
                      onTap: () {},
                      dense: true,
                      title: const Text(
                        'Report Group',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      trailing: const Icon(Icons.report),
                    ),
                    const Divider(),
                    ListTile(
                      onTap: () async {
                        if (checkForPosition(tile: groupTile, user: per.personalDetails) == "Creator & Admin 👑") {
                          return;
                        } else {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                          await FirebaseService.removePersonFromGroup(tile: groupTile, personal: per.personalDetails);
                        }
                      },
                      dense: true,
                      title: Text(
                        'Leave group',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.red.shade300,
                        ),
                      ),
                      trailing: Icon(Icons.exit_to_app, color: Colors.red.shade300),
                    ),
                    const Divider(),
                    (checkForPosition(tile: groupTile, user: per.personalDetails) == "Creator & Admin 👑")
                        ? ListTile(
                            onTap: () async {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MainScreen()));
                              await FirebaseService.deleteGroup(tile: groupTile);
                            },
                            dense: true,
                            title: const Text(
                              'Delete Group',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            trailing: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        : Container(),
                    (checkForPosition(tile: groupTile, user: per.personalDetails) == "Creator & Admin 👑") ? const Divider() : Container()
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  checkForPosition({required GroupTile tile, required UserDetails user}) {
    if (tile.createdBy.id == user.id) {
      return "Creator & Admin 👑";
    }
    for (var i = 0; i < tile.adminUsers.length; i++) {
      if (tile.adminUsers[i].id == user.id) {
        return "Admin";
      }
    }
    return "Member";
  }

  isAdmin({required GroupTile tile, required UserDetails user}) {
    if (tile.createdBy.id == user.id) {
      return true;
    }
    for (var i = 0; i < tile.adminUsers.length; i++) {
      if (tile.adminUsers[i].id == user.id) {
        return true;
      }
    }
    return false;
  }
}
