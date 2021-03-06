import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/UI/Pages/chat_screen.dart';
import 'package:chatbuzz/UI/Widgets/edit_personal_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PinnedChatBox extends StatefulWidget {
  ConversationTile conversationTile;
  PinnedChatBox({Key? key, required this.conversationTile}) : super(key: key);

  @override
  State<PinnedChatBox> createState() => _PinnedChatBoxState();
}

class _PinnedChatBoxState extends State<PinnedChatBox> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: () {
        toggleChatType(context: context, conversationTile: widget.conversationTile);
      },
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => ChatScreen(
              conversationTile: widget.conversationTile,
            ),
          ),
        );
      },
      autofocus: true,
      dense: widget.conversationTile.isPinnedChat,
      title: Text(
        widget.conversationTile.name,
        style: TextStyle(fontWeight: !widget.conversationTile.isPinnedChat ? FontWeight.bold : null),
      ),
      trailing: !widget.conversationTile.isPinnedChat
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
                  decoration: BoxDecoration(
                    color: widget.conversationTile.unreadCount != 0 ? Colors.blue : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: widget.conversationTile.unreadCount != 0
                      ? Text(
                          widget.conversationTile.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        )
                      : null,
                )
              ],
            )
          : null,
      tileColor: Theme.of(context).brightness == Brightness.light ? const Color(0xFFF2F2F2) : Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      subtitle: Text(
        widget.conversationTile.lastMessage,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontSize: 13),
      ),
      leading: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  widget.conversationTile.avatarUrl,
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
