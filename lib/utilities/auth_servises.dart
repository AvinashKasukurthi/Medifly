import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medifly/home_screen.dart';
import 'package:medifly/main.dart';
import 'categories_data.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:provider/provider.dart';

bool signed = false;

class PhoneAuth extends StatefulWidget {
  static String id = 'phoneAuth';
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth> {
  String phoneNumber;
  String verificationCode;

  TextEditingController otpController;
  TextEditingController phoneController;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String verificationId;

  @override
  void initState() {
    otpController = TextEditingController();
    phoneController = TextEditingController();
    super.initState();
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      verificationId = verId;
    };

    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResend]) {
      verificationId = verId;
    };

    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      firebaseAuth.signInWithCredential(auth).then((UserCredential value) {
        if (value.user != null) {
          User user = value.user;

          userAuthorized(user);
        } else {
          debugPrint('user not authorized');
        }
      }).catchError((error) {
        debugPrint('error : $error');
      });
    };

    final PhoneVerificationFailed veriFailed =
        (FirebaseAuthException exception) {
      print('${exception.message}');
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNo,
      codeAutoRetrievalTimeout: autoRetrieve,
      codeSent: smsCodeSent,
      timeout: const Duration(seconds: 5),
      verificationCompleted: verifiedSuccess,
      verificationFailed: veriFailed,
    );
  }

  void verifyOTP(String smsCode) async {
    var _authCredential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
    firebaseAuth
        .signInWithCredential(_authCredential)
        .then((UserCredential result) {
      User user = result.user;

      if (user != null) {
        userAuthorized(user);
      }

      ///go To Next Page
    }).catchError((error) {
      Navigator.pop(context);
    });
  }

  userAuthorized(User user) {
    print('object');

    setVisitData(user);
    Navigator.pushNamed(context, HomeScreen.id);
  }

  bool isOTP = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 5.0),
                  width: 200.0,
                  //Medifly icon on the login screen which fits the size ass per screen typo
                  child: Image.asset(
                    'images/medifly.png',
                  ),
                ),
              ),
              //Medify text displays on loginscreen of font open sans with fontWeight 300 & fontSize of 70 pixels
              Flexible(
                child: Text(
                  'Medifly',
                  style: TextStyle(
                    letterSpacing: 2.2,
                    fontSize: 70.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Text(
                'Being part of your Health',
                style: TextStyle(color: Colors.black26),
              ),
              Flexible(
                child: SizedBox(
                  height: 80.0,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    color: kCardsColor,
                    borderRadius: BorderRadius.circular(30.0)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                            color: kCardsColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(30),
                              topLeft: Radius.circular(30),
                            )),
                        child: Text('+91'),
                      ),
                    ),
                    Expanded(
                      flex: 10,
                      child: Container(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: phoneController,
                          decoration: InputDecoration(
                            fillColor: kCardsColor,
                            filled: true,
                            hintText: 'Enter phone Number',
                            border: OutlineInputBorder(
                              // borderSide: BorderSide.none,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    fillColor: kCardsColor,
                    filled: true,
                    hintText: 'Enter OTP',
                    border: OutlineInputBorder(
                      // borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: RaisedButton(
                  color: kPrimaryColorBlue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  onPressed: () async {
                    if (isOTP) {
                      verifyOTP(otpController.text.trim());
                    } else if (!isOTP) {
                      verifyPhone('+91' + phoneController.text.trim());
                      isOTP = true;
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50.0,
                      vertical: 14,
                    ),
                    child: Text(
                      'Submit',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
