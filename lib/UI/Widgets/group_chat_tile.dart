import 'package:chatbuzz/Data/models/group_tile.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class GroupChatTile extends StatelessWidget {
  final GroupTile groupTile;
  const GroupChatTile({Key? key, required this.groupTile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => {
      //   Navigator.push(
      //     context,
      //     CupertinoPageRoute(
      //       builder: (context) => GroupChatScreen(groupTile: groupTile),
      //     ),
      //   )
      // },
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).splashColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: groupTile.joinedUsers.length < 10 ? groupTile.joinedUsers.length : 10,
                itemBuilder: (context, index) {
                  return Container(
                    height: 20,
                    width: 20,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(groupTile.joinedUsers[index].profilePicture),
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
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
            const SizedBox(height: 5),
            Row(
              children: [
                SizedBox(
                  width: 200,
                  child: Text.rich(
                    TextSpan(
                      text: groupTile.lastMessage,
                      children: [
                        TextSpan(
                          text: "~ ${groupTile.lastMessageSender}",
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.6),
                          ),
                        ),
                      ],
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodyText1!.color,
                      ),
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
                const Spacer(),
                Text(
                  DateFormat.jm().format(groupTile.lastMessagetime),
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ],
            ),
          ],
        ),
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