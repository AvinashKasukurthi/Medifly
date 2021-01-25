import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:medifly/home_screen.dart';
import 'package:medifly/main.dart';
import 'package:medifly/utilities/constants.dart';

bool signed = false;

class PhoneAuth extends StatefulWidget {
  static String id = 'phoneAuth';
  @override
  _PhoneAuthState createState() => _PhoneAuthState();
}

class _PhoneAuthState extends State<PhoneAuth>
    with SingleTickerProviderStateMixin {
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
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColorBlue),
              ),
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
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'images/doc.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                stops: [0.1, 0.6, 0.9],
                colors: [Colors.black54, Colors.white54, Colors.white],
              ),
            ),
          ),
          SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      padding: EdgeInsets.only(top: 5.0),
                      width: 200,
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
                    style: TextStyle(color: Colors.black54),
                  ),
                  Flexible(
                    child: SizedBox(
                      height: 80.0,
                    ),
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
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
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  (isOTP)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 16.0, right: 10, left: 10),
                          child: TextField(
                            textAlign: TextAlign.center,
                            controller: otpController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              fillColor: kCardsColor,
                              filled: true,
                              hintText: 'Enter OTP',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        )
                      : Container(),
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
                          if (phoneController.text.startsWith('+91')) {
                            if (phoneController.text.trim().length == 13)
                              verifyPhone(phoneController.text.trim());
                            else
                              Fluttertoast.showToast(
                                msg: "You have Entered wrong phone number.",
                                backgroundColor: Colors.black45,
                                textColor: Colors.white,
                              );
                          } else if (!phoneController.text.startsWith('+91')) {
                            if (phoneController.text.trim().length == 10) {
                              verifyPhone('+91' + phoneController.text.trim());

                              setState(() {
                                isOTP = true;
                              });
                            } else
                              Fluttertoast.showToast(
                                msg: "You have Entered wrong phone number.",
                                backgroundColor: Colors.black45,
                                textColor: Colors.white,
                              );
                          }
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50.0,
                          vertical: 14,
                        ),
                        child: Text(
                          !isOTP ? 'Submit' : 'Login',
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
          )
        ],
      ),
    );
  }
}
