import 'package:chatbuzz/UI/Pages/chat_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PinnedChatBox extends StatefulWidget {
  bool isPinnedChatBox;
  PinnedChatBox({Key? key, required this.isPinnedChatBox}) : super(key: key);

  @override
  State<PinnedChatBox> createState() => _PinnedChatBoxState();
}

class _PinnedChatBoxState extends State<PinnedChatBox> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => const ChatScreen(),
          ),
        );
      },
      autofocus: true,
      dense: widget.isPinnedChatBox,
      title: Text(
        "Vishal Singh",
        style: TextStyle(fontWeight: !widget.isPinnedChatBox ? FontWeight.bold : null),
      ),
      trailing: !widget.isPinnedChatBox
          ? Column(
              children: [
                Text(
                  "08:30 PM",
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
                    fontSize: 10,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  height: 20,
                  width: 20,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
                    "5",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                )
              ],
            )
          : null,
      tileColor: Theme.of(context).brightness == Brightness.light ? const Color(0xFFF2F2F2) : Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      subtitle: const Text(
        "Hey, how are you?",
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13),
      ),
      leading: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 40,
            width: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.pexels.com/photos/771742/pexels-photo-771742.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              height: 10,
              width: 10,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightGreen,
              ),
            ),
          )
        ],
      ),
    );
  }
}
