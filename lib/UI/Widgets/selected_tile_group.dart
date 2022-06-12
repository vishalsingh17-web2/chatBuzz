import 'package:chatbuzz/Controller/group_controller.dart';
import 'package:chatbuzz/Data/models/user_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectedTileGroup extends StatelessWidget {
  final UserDetails user;
  const SelectedTileGroup({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final groupController = Provider.of<GroupController>(context, listen: false);
        groupController.clearSelectedUsers();
        return true;
      },
      child: Consumer<GroupController>(
        builder: (context, groups, child) {
          return Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).splashColor,
                ),
                margin: const EdgeInsets.only(top: 8, right: 12),
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: NetworkImage(user.profilePicture),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user.name,
                      style: const TextStyle(fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    groups.removeSelectedUser(user);
                  },
                  child: Container(
                    width: 25,
                    height: 25,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.red.shade700,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
