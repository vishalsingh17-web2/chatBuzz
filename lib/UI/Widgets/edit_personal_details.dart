import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Data/models/chat_data_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

editPersonalDetails({required BuildContext context, required String name, String? bio}) {
  TextEditingController nameController = TextEditingController(text: name);
  TextEditingController bioController = TextEditingController(text: bio ?? "");
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Edit personal details",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter your name',
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: bioController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Enter your bio',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.light ? Colors.grey[200] : Colors.grey[900],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<PersonalDetails>(context, listen: false).updateUserDetails(
                    name: nameController.text,
                    bio: bioController.text,
                  );
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      );
    },
  );
}

toggleChatType({required BuildContext context, required ConversationTile conversationTile}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () {
                if (conversationTile.isPinnedChat) {
                  Provider.of<ChatController>(context, listen: false).unpinChat(conversationTile);
                } else {
                  Provider.of<ChatController>(context, listen: false).pinChat(conversationTile);
                }
              },
              child: conversationTile.isPinnedChat ? const Text("Unpin this chat") : const Text("Pin this chat"),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {},
              child: const Text("Delete this chat", style: TextStyle(color: Colors.red)),
            ),
          ],
        ),
      );
    },
  );
}
