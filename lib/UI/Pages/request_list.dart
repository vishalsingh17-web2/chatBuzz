import 'package:chatbuzz/Controller/group_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestList extends StatelessWidget {
  const RequestList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
        title: Text(
          "Join groups",
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Consumer<GroupController>(
        builder: (context, groups, child) {
          return RefreshIndicator(
            onRefresh: () async {
              var details = Provider.of<PersonalDetails>(context, listen: false);
              await groups.initializeRequestToJoinGroup(personal: details.personalDetails);
            },
            child: ListView.builder(
              itemCount: groups.requestsList.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).splashColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(
                                groups.requestsList[index].createdBy.profilePicture,
                              ),
                              radius: 10,
                            ),
                            SizedBox(
                              width: 170,
                              child: Text.rich(
                                TextSpan(
                                  text: " ${groups.requestsList[index].createdBy.name}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  children: const [
                                    TextSpan(
                                      text: " requested you to join ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Theme.of(context).textTheme.bodyText1!.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          groups.requestsList[index].groupName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.bodyText1!.color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  expandedAlignment: Alignment.topLeft,
                  childrenPadding: const EdgeInsets.only(left: 20, top: 10),
                  children: [
                    Container(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Members",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 190,
                      child: ListView.builder(
                        itemCount: groups.requestsList[index].userDetailsList.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            contentPadding: const EdgeInsets.only(left: 0),
                            dense: true,
                            title: Text(
                              groups.requestsList[index].userDetailsList[i].name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                groups.requestsList[index].userDetailsList[i].profilePicture,
                              ),
                              radius: 15,
                            ),
                            trailing: groups.requestsList[index].joinedUsers.contains(groups.requestsList[index].userDetailsList[i].email)
                                ? Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Text(
                                      "Joined",
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    child: const Text(
                                      "Requested",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                          );
                        },
                      ),
                    ),
                    Consumer<PersonalDetails>(
                      builder: (context, personalDetails, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: OutlinedButton(
                                onPressed: () {
                                  groups.joinGroup(tile: groups.requestsList[index], personalDetails: personalDetails.personalDetails);
                                },
                                child: const Text(
                                  "Join",
                                  style: TextStyle(),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 3,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.red,
                                ),
                                onPressed: () {
                                  groups.deleteGroupRequest(tile: groups.requestsList[index], personalDetails: personalDetails.personalDetails);
                                },
                                child: const Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 20)
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
