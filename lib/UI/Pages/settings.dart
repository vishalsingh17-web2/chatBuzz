import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/Controller/login_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Controller/theme_controller.dart';
import 'package:chatbuzz/UI/Pages/chat_screen.dart';
import 'package:chatbuzz/UI/Pages/login_page.dart';
import 'package:chatbuzz/UI/Widgets/edit_personal_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  bool show = false;
  @override
  Widget build(BuildContext context) {
    return Consumer3<PersonalDetails, ThemeController, LoginController>(
      builder: (context, details, theme, login, child) {
        return Container(
          padding: const EdgeInsets.all(12),
          child: ListView(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                child: const Text(
                  "Settings",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileImage(
                            link: details.personalDetails.profilePicture,
                          ),
                        ),
                      ),
                      child: Hero(
                        tag: "ProfilePic",
                        child: Container(
                          margin: const EdgeInsets.only(left: 10),
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage(
                                details.personalDetails.profilePicture,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.personalDetails.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 200,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                show = !show;
                              });
                            },
                            child: Text(
                              details.personalDetails.bio,
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.5),
                              ),
                              overflow: show ? TextOverflow.visible : TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          editPersonalDetails(
                            context: context,
                            name: details.personalDetails.name,
                            bio: details.personalDetails.bio,
                          );
                        },
                        icon: const Icon(Icons.edit),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.dark_mode),
                trailing: Switch(
                  value: theme.isDarkTheme,
                  onChanged: (value) {
                    theme.changeTheme();
                  },
                ),
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.account_box),
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Notifications",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.notifications),
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Chat Settings",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.chat),
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Data & Storage",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.data_usage),
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Privacy & Security",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.security),
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "About",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.info),
              ),
              ListTile(
                onTap: () {},
                title: const Text(
                  "Help & Feedback",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.help),
              ),
              const SizedBox(height: 30),
              ListTile(
                onTap: () async {
                  var userList = Provider.of<ChatController>(context, listen: false);
                  userList.clearAllChats();
                  Navigator.pushReplacement(context, CupertinoPageRoute(builder: (context) => const LoginPage()));
                  await login.logOut();
                },
                title: const Text(
                  "Log Out",
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                leading: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
        );
      },
    );
  }
}
