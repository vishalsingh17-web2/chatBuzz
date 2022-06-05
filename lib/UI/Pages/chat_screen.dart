import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:chatbuzz/UI/Widgets/chat_box.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  ConversationTile conversationTile;
  ChatScreen({Key? key, required this.conversationTile}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.animateTo(
        _controller.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(widget.conversationTile.name, style: TextStyle(color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white)),
        leadingWidth: 40,
        leading: InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileImage(
                link: widget.conversationTile.avatarUrl,
              ),
            ),
          ),
          child: Hero(
            tag: "ProfilePic",
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(
                    widget.conversationTile.avatarUrl,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        controller: _controller,
        physics: const BouncingScrollPhysics(),
        itemCount: chats.length,
        itemBuilder: (context, index) {
          if (chats.length - 1 == index) {
            return Column(
              children: [
                ChatBox(chatData: chats[index]),
                const SizedBox(height: 60),
              ],
            );
          }
          return ChatBox(chatData: chats[index]);
        },
      ),
      bottomSheet: TextFormField(
        decoration: InputDecoration(
          hintText: 'Type a message',
          contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.send),
          ),
        ),
      ),
    );
  }
}

class ProfileImage extends StatefulWidget {
  String link;
  ProfileImage({Key? key, required this.link}) : super(key: key);

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "ProfilePic",
      child: Center(
        child: Image.network(
          widget.link,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
