import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medifly/main.dart';
import 'package:medifly/utilities/auth_servises.dart';

import 'package:medifly/utilities/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseFirestore ref = FirebaseFirestore.instance;

class ProfileScreen extends StatefulWidget {
  static String id = 'ProfileScreen';
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String username;
  String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: kPrimaryColorBlue,
        centerTitle: true,
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.w400),
        ),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('profiles').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Widget profile;
                  final profileData = snapshot.data.docs;
                  for (var proileDataCard in profileData) {
                    if (phoneNo == proileDataCard.data()['phonenumber']) {
                      profile = ProfileDetails(
                        email: proileDataCard.data()['email'] ,
                        phonenumber: proileDataCard.data()['phonenumber'],
                        usertext: proileDataCard.data()['username'],
                      );
                    }
                  }
                  return profile;
                }
                return Container();
              },
            )
          ],
        ),
      )),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  ProfileDetails({this.usertext, this.email, this.phonenumber});
  String nametext;
  String emailText;
  final String usertext;
  final String email;
  final String phonenumber;

  final messageTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Future<void> showUserChange() {
      print('object');
      return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            // backgroundColor: kPrimaryColorBlue,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: messageTextController,
                  onChanged: (value) {
                    nametext = value;
                    print(nametext);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 8,
                ),
                child: RaisedButton(
                  onPressed: () async {
                    if ( nametext == null) {
                      nametext = '';
                    }
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    phoneNo = preferences.getString('phoneNo');
                    print(nametext);
                    print(phoneNo);
                    
                    ref.collection("profiles").doc('$phoneNo').update(
                      {
                        'username': nametext,
                      },
                    );
                    Navigator.pop(context);

                    messageTextController.clear();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                  color: kPrimaryColorBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              )
            ],
          );
        },
      );
    }

    Future<void> showEmailChange() {
      print('object');
      return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            // backgroundColor: kPrimaryColorBlue,
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: messageTextController,
                  onChanged: (value) {
                    emailText = value;
                    print(nametext);
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 70,
                  vertical: 8,
                ),
                child: RaisedButton(
                  onPressed: () async {
                    if (emailText == null) {
                      emailText = '';
                    }
                    SharedPreferences preferences =
                        await SharedPreferences.getInstance();
                    phoneNo = preferences.getString('phoneNo');
                    print(nametext);
                    print(phoneNo);
                    if (emailText.isEmpty || emailText == null) {
                      emailText = '';
                    }
                    ref.collection("profiles").doc('$phoneNo').update(
                      {
                        'email': emailText,
                      },
                    );
                    Navigator.pop(context);

                    messageTextController.clear();
                  },
                  child: Text(
                    'Save',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 18),
                  ),
                  color: kPrimaryColorBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                ),
              )
            ],
          );
        },
      );
    }

    return Column(
      children: [
        ListTile(
          onTap: () => showUserChange(),
          trailing: Icon(
            CupertinoIcons.pencil,
            color: kPrimaryColorBlue,
            size: 18,
          ),
          leading: Icon(
            Icons.person,
            color: kPrimaryColorBlue,
          ),
          title: Text((usertext.isEmpty) ? 'Enter Username' : usertext),
        ),
        ListTile(
          onTap: () => showEmailChange(),
          trailing: Icon(
            CupertinoIcons.pencil,
            color: kPrimaryColorBlue,
            size: 18,
          ),
          leading: Icon(
            Icons.mail,
            color: kPrimaryColorBlue,
          ),
          title: Text((email.isEmpty) ? 'Enter Email' : email),
        ),
        ListTile(
          leading: Icon(
            CupertinoIcons.phone_solid,
            color: kPrimaryColorBlue,
          ),
          title: Text(phoneNo),
        ),
      ],
    );
  }
}