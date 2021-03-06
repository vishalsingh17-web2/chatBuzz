import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  final ChatData chatData;
  const ChatBox({Key? key, required this.chatData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: chatData.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // !chatData.isMe
          //     ? Container(
          //         margin: const EdgeInsets.symmetric(horizontal: 5),
          //         width: 40,
          //         height: 40,
          //         decoration: BoxDecoration(
          //           shape: BoxShape.circle,
          //           image: DecorationImage(
          //             image: NetworkImage(
          //               chatData.avatarUrl,
          //             ),
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //       )
          //     : Container(),
          chatData.isMe
              ? Container(
                  width: MediaQuery.of(context).size.width * 0.75,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: RichText(
                      textAlign: TextAlign.right,
                      text: TextSpan(
                        text: chatData.message,
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                        children: [
                          TextSpan(
                            text: '\n',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextSpan(
                            text: chatData.time,
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.white.withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  width: MediaQuery.of(context).size.width * 0.75,
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[200],
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    child: RichText(
                      text: TextSpan(
                        text: chatData.message,
                        style: Theme.of(context).textTheme.bodyText1,
                        children: [
                          TextSpan(
                            text: '\n',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                          TextSpan(
                            spellOut: true,
                            text: chatData.time,
                            style: Theme.of(context).textTheme.caption!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Theme.of(context).unselectedWidgetColor,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
