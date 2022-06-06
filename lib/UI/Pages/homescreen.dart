import 'dart:async';

import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/UI/Pages/search_screen.dart';
import 'package:chatbuzz/UI/Widgets/pinned_chat_box.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ChatController>(
      builder: (context, chats, child) {
        if (chats.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: ListTile(
                      title: const Text("Search People"),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SearchScreen(),
                            ),
                          );
                        },
                        child: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  chats.pinnedChats.isEmpty
                      ? Container()
                      : Container(
                          padding: const EdgeInsets.only(left: 10, bottom: 10),
                          width: double.infinity,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: const Text(
                            "Pinned Chats",
                            style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                          ),
                        ),
                  SizedBox(
                    height: chats.recentChats.isEmpty ? MediaQuery.of(context).size.height * 0.7 : 250,
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      primary: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2,
                      ),
                      itemBuilder: (context, index) {
                        return PinnedChatBox(
                          conversationTile: chats.pinnedChats[index],
                        );
                      },
                      itemCount: chats.pinnedChats.length,
                    ),
                  ),
                ],
              ),
              chats.recentChats.isEmpty
                  ? chats.pinnedChats.isEmpty
                      ? const Center(
                          child: Text(
                            "No Recent Chats\nStart a conversation\nby searching for a user",
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : Container()
                  : DraggableScrollableSheet(
                      initialChildSize: chats.pinnedChats.isEmpty ? 0.93 : 0.60,
                      maxChildSize: 0.93,
                      minChildSize: chats.pinnedChats.isEmpty ? 0.93 : 0.60,
                      builder: (context, scrollController) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: chats.recentChats.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(top: 10),
                                      height: 10,
                                      width: 50,
                                      decoration: BoxDecoration(color: Colors.grey.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                                    ),
                                    const ListTile(
                                      title: Text(
                                        "📨 Recent chats",
                                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                      // trailing: InkWell(
                                      //   onTap: () {},
                                      //   child: const Icon(Icons.search),
                                      // ),
                                    ),
                                    PinnedChatBox(
                                      conversationTile: chats.recentChats[index],
                                    )
                                  ],
                                );
                              }
                              return PinnedChatBox(conversationTile: chats.recentChats[index]);
                            },
                            controller: scrollController,
                          ),
                        );
                      },
                    )
            ],
          ),
        );
      },
    );
  }
}
