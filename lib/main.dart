import 'package:chatbuzz/Controller/chat_controller.dart';
import 'package:chatbuzz/Controller/group_controller.dart';
import 'package:chatbuzz/Controller/login_controller.dart';
import 'package:chatbuzz/Controller/personal_detail_controller.dart';
import 'package:chatbuzz/Controller/theme_controller.dart';
import 'package:chatbuzz/UI/Pages/call_page.dart';
import 'package:chatbuzz/UI/Pages/homescreen.dart';
import 'package:chatbuzz/UI/Pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'UI/Pages/group.dart';
import 'UI/Pages/settings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('theme');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => PersonalDetails()),
        ChangeNotifierProvider(create: (_) => GroupController()),
      ],
      child: Consumer<ThemeController>(
        builder: (context, theme, child) {
          return MaterialApp(
            title: 'ChatBuzz',
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData(brightness: Brightness.dark),
            themeMode: theme.selectedtheme,
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: FirebaseAuth.instance.currentUser != null ? const MainScreen() : const LoginPage(),
          );
        },
      ),
    );
  }
}

List screens = const [
  HomeScreen(),
  Group(),
  CallPage(),
  Setting(),
];

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      Future.microtask(() async {
        var details = Provider.of<PersonalDetails>(context, listen: false);
        var userList = Provider.of<ChatController>(context, listen: false);
        var groupList = Provider.of<GroupController>(context, listen: false);
        await details.fetchUserDetails();
        await userList.initializeUsersList();
        await userList.initializeAllChats();
        await groupList.initializeRequestToJoinGroup(personal: details.personalDetails);
      });
    });
    super.initState();
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (index == 0) {
          return Future.value(true);
        } else {
          setState(() {
            index = 0;
          });
          return Future.value(false);
        }
      },
      child: Consumer<LoginController>(
        builder: (context, login, child) {
          if (login.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SafeArea(
            child: Scaffold(
              body: screens[index],
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: index,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Theme.of(context).brightness == Brightness.dark ? Colors.blue.shade100 : Colors.grey,
                onTap: (value) => setState(() => index = value),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.message), label: "Chats"),
                  BottomNavigationBarItem(icon: Icon(Icons.group), label: "Group Chats"),
                  BottomNavigationBarItem(icon: Icon(Icons.call), label: "Call"),
                  BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
