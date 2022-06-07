import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/UI/Pages/chat_screen.dart';
import 'package:chatbuzz/UI/Widgets/edit_personal_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        widget.conversationTile.userDetails.name,
        style: TextStyle(fontWeight: !widget.conversationTile.isPinnedChat ? FontWeight.bold : null),
      ),
      trailing: !widget.conversationTile.isPinnedChat
          ? Text(
              widget.conversationTile.time == "" || widget.conversationTile.time == " " ? "" : DateFormat.jm().format(DateTime.parse(widget.conversationTile.time)),
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyText1!.color!.withOpacity(0.5),
                fontSize: 10,
              ),
            )
          : null,
      tileColor: Theme.of(context).brightness == Brightness.light ? const Color(0xFFF2F2F2) : Colors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      subtitle: widget.conversationTile.lastMessage == "" || widget.conversationTile.lastMessage == " "
          ? null
          : Text(
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
                  widget.conversationTile.userDetails.profilePicture,
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
