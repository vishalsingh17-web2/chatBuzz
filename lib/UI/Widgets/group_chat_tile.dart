import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupChatTile extends StatelessWidget {
  final GroupTile groupTile;
  const GroupChatTile({Key? key, required this.groupTile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).splashColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  groupTile.createdBy.profilePicture,
                ),
                radius: 10,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            groupTile.groupName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyText1!.color,
            ),
          ),
        ],
      ),
    );
  }
}
// Column(
//       children: [
//         ListTile(
//           dense: true,
//           title: Text(
//             groupTile.groupName,
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//           subtitle: Text(
//             groupTile.lastMessage,
//             overflow: TextOverflow.ellipsis,
//             style: const TextStyle(fontSize: 12),
//           ),
//           leading: const Icon(Icons.group),
//           trailing: Text(
//             groupTile.lastMessagetime == "" || groupTile.lastMessagetime == " " ? "" : DateFormat.jm().format(DateTime.parse(groupTile.lastMessagetime)),
//             style: TextStyle(
//               color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
//               fontSize: 10,
//             ),
//           ),
//         ),
//         const SizedBox(height: 10),
//       ],
//     );