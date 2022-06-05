import 'package:chatbuzz/UI/Widgets/pinned_chat_box.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
                    onTap: () {},
                    child: const Icon(Icons.search),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10, bottom: 10),
                width: double.infinity,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: const Text(
                  "Pinned Chats",
                  style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 250,
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
                      isPinnedChatBox: true,
                    );
                  },
                  itemCount: 10,
                ),
              ),
            ],
          ),
          DraggableScrollableSheet(
            initialChildSize: 0.60,
            maxChildSize: 0.95,
            minChildSize: 0.60,
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
                  itemCount: 20,
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
                          PinnedChatBox(isPinnedChatBox: false)
                        ],
                      );
                    }
                    return PinnedChatBox(isPinnedChatBox: false);
                  },
                  controller: scrollController,
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
