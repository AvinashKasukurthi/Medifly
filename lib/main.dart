import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medifly/category_page.dart';
import 'package:medifly/home_screen.dart';
import 'package:flutter/services.dart';
import 'package:medifly/hospitalspage.dart';
import 'package:medifly/utilities/auth_servises.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/profile_Screen.dart';
import 'package:medifly/search_screen.dart';
import 'package:medifly/utilities/recenttoken_screen.dart';

import 'package:medifly/utilities/time_info.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

var phoneNo;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  phoneNo = preferences.getString('phoneNo');
  await Firebase.initializeApp();
  runApp(MyApp());

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  var homeScreenState;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SlotData>(
      create: (context) {
        return SlotData();
      },
      child: ChangeNotifierProvider<CategoryData>(
        create: (context) {
          return CategoryData();
        },
        child: MaterialApp(
          title: 'Medifly',
          //To off the debug tag in all screens
          debugShowCheckedModeBanner: false,
          home: (phoneNo == null) ? PhoneAuth() : HomeScreen(),
          routes: {
            PhoneAuth.id: (context) => PhoneAuth(),
            HomeScreen.id: (context) => HomeScreen(),
            ProfileScreen.id: (context) => ProfileScreen(),
            SearchScreen.id: (context) => SearchScreen(),
            RecentCards.id: (context) => RecentCards(),
            HospitalPage.id: (context) => HospitalPage(),
            CategoryPage.id: (context) => CategoryPage(),
          },
        ),
      ),
    );
  }
}

bool _alreadyVisited;

setVisitingFlag(User user) async {
  print('phone');
  SharedPreferences preferences = await SharedPreferences.getInstance();
  preferences.setString('phoneNo', user.phoneNumber);
  print('phone number Invoked');
  _alreadyVisited = true;
}

setVisitData(User user) async {
  setVisitingFlag(user);

  print('object');
}
