import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/Controller/group_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:chatbuzz/UI/Widgets/selected_tile_group.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var groupController = Provider.of<GroupController>(context, listen: false);
        groupController.clearSelectedUsers();
        return true;
      },
      child: Consumer2<ChatController, GroupController>(
        builder: (context, chats, groups, child) {
          return SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).iconTheme.color,
                ),
                elevation: 0,
                title: Text(
                  'Create Group',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              body: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextFormField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Group Name',
                          prefixIcon: const Icon(Icons.group),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    groups.selectedUsers.isEmpty
                        ? Container()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 12),
                              const Text("Selected members", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 20),
                              SizedBox(
                                height: 120,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: groups.selectedUsers.length,
                                  itemBuilder: (context, index) {
                                    return SelectedTileGroup(user: groups.selectedUsers[index]);
                                  },
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 8),
                    const Divider(),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Select members',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: chats.allChats.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              groups.addSelectedUser(chats.allChats[index].userDetails);
                            },
                            dense: true,
                            title: Text(chats.allChats[index].userDetails.name),
                            subtitle: Text(chats.allChats[index].userDetails.email),
                            trailing: IconButton(
                              icon: const Icon(Icons.person_add),
                              onPressed: () {
                                groups.addSelectedUser(chats.allChats[index].userDetails);
                              },
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                chats.allChats[index].userDetails.profilePicture,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Container(
                margin: const EdgeInsets.only(right: 20, bottom: 20),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_controller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Group name cannot be empty',
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    } else {
                      UserDetails per = Provider.of<PersonalDetails>(context, listen: false).personalDetails;
                      bool check = await groups.createGroup(tile: groups.selectedUsers, groupName: _controller.text, currentUser: per);
                      if (check) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Group already exists',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Group Created Successfully',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                        );
                        Provider.of<GroupController>(context, listen: false).clearSelectedUsers();
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Text('Create'),
                ),
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
            ),
          );
        },
      ),
    );
  }
}
