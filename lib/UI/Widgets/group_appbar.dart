import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:flutter/material.dart';

class GroupAppBar extends StatelessWidget {
  final GroupTile tile;
  const GroupAppBar({Key? key, required this.tile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 30,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tile.joinedUsers.length < 10 ? tile.joinedUsers.length : 10,
                  itemBuilder: (context, index) {
                    return Container(
                      height: 30,
                      alignment: index % 2 == 0 ? Alignment.topCenter : Alignment.bottomCenter,
                      child: Container(
                        height: 20,
                        width: 20,
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(tile.joinedUsers[index].profilePicture),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Text(
                tile.groupName,
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
