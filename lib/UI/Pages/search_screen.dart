import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Provider.of<ChatController>(context, listen: false).clearSearchResults();
        Navigator.of(context).pop();
        return true;
      },
      child: Consumer2<ChatController, PersonalDetails>(
        builder: (context, chatController,per ,child) {
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
              ),
              title: TextFormField(
                onChanged: ((value) {
                  chatController.searchUser(value);
                }),
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(8),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
                  prefixIcon: Icon(Icons.search),
                  labelText: "Email/Name",
                  labelStyle: TextStyle(fontSize: 16),
                ),
              ),
            ),
            body: chatController.searchResults.isEmpty
                ? Container()
                : ListView.builder(
                    itemBuilder: (context, index) {
                      return ListTile(
                        dense: true,
                        title: Text(chatController.searchResults[index].name),
                        subtitle: Text(chatController.searchResults[index].email),
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(chatController.searchResults[index].profilePicture),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.person_add),
                          onPressed: () {
                            chatController.addNewChat(chatController.searchResults[index], per.personalDetails);
                            chatController.clearSearchResults();
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                    itemCount: chatController.searchResults.length,
                  ),
          );
        },
      ),
    );
  }
}
