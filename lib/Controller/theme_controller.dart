import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeController extends ChangeNotifier {
  List<ThemeMode> theme = [ThemeMode.light, ThemeMode.dark];
  bool isDarkTheme = false;
  ThemeMode selectedtheme = Hive.box('theme').get('selectedTheme') == null ? ThemeMode.light : Hive.box('theme').get('selectedTheme')==1?ThemeMode.dark:ThemeMode.light;
  ThemeController() {
    init();
  }
  init() {
    bool check = Hive.box('theme').get('selectedTheme') != null;
    if (check) {
      if (Hive.box('theme').get('selectedTheme') == 1) {
        selectedtheme = theme[1];
        isDarkTheme = true;
        notifyListeners();
        Hive.box('theme').put('selectedTheme', 1);
      } else {
        selectedtheme = theme[0];
        isDarkTheme = false;
        notifyListeners();
        Hive.box('theme').put('selectedTheme', 0);
      }
    } else {
      selectedtheme = theme[0];
      isDarkTheme = false;
      notifyListeners();
      Hive.box('theme').put('selectedTheme', 0);
    }
    print(selectedtheme);
    notifyListeners();
  }

  void changeTheme() {
    print(Hive.box('theme').get('selectedTheme'));
    if (selectedtheme == theme[0]) {
      selectedtheme = theme[1];
      isDarkTheme = true;
      notifyListeners();
      Hive.box('theme').put('selectedTheme', 1);
    } else {
      selectedtheme = theme[0];
      isDarkTheme = false;
      notifyListeners();
      Hive.box('theme').put('selectedTheme', 0);
    }
  }
}
