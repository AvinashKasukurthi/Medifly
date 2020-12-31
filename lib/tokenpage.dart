import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:provider/provider.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/department_icons.dart';
import 'package:medifly/utilities/time_info.dart';

FirebaseFirestore firebaseref = FirebaseFirestore.instance;

class TokenScreen extends StatefulWidget {
  final String hospitalname;
  final String address;
  final String day;
  final String year;
  final String month;

  static String id = 'TokenScreen';
  TokenScreen(
      {this.address,
      this.hospitalname,
      this.day,
      this.month,
      this.year,
      Key key})
      : super(key: key);

  @override
  _TokenScreenState createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kPrimaryColorBlue,
        body: Container(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              children: [
                Container(
                  // width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center ,
                      children: [
                        Text(
                          'Hospital: ${widget.hospitalname}',
                          style: kNormalText.copyWith(fontSize: 18),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Address: ${widget.address} ',
                          textAlign: TextAlign.start,
                          style: kNormalText.copyWith(
                              fontSize: 18, color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: kCardsColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Image.asset(
                                    'images/${departmentIcons[Provider.of<CategoryData>(context).category]}'),
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.start,
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      Provider.of<CategoryData>(context)
                                          .category,
                                      style: kNormalText.copyWith(
                                        color: kPrimaryColorBlue,
                                        fontSize: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_today,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              left: 8.0,
                                            ),
                                            child: Text(
                                              '${widget.day}/${widget.month}/${widget.year}',
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w300),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 30.0,
                                        ),
                                        child: Text(
                                          Provider.of<SlotData>(context).slot,
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      decoration: BoxDecoration(
                                        color: kPrimaryColorBlue,
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'ID : xxxxxxxxxXXX',
                            style: TextStyle(
                                fontSize: 18.0, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
