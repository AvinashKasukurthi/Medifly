import 'package:flutter/material.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:medifly/utilities/time_info.dart';

FirebaseFirestore timeref = FirebaseFirestore.instance;

class Timewidget extends StatefulWidget {
  Timewidget({this.hospitalname, @required this.timeList});
  final String hospitalname;
  final List timeList;

  @override
  _TimewidgetState createState() => _TimewidgetState();
}

class _TimewidgetState extends State<Timewidget> {
  @override
  void initState() {
    super.initState();
    print(widget.timeList);
    print('object invoked');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorBlue,
      body: Container(
        child: ListView.builder(
          itemCount: widget.timeList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: GestureDetector(
                onTap: () {
                   Provider.of<SlotData>(context, listen: false)
                      .selectSlot(widget.timeList[index]);
                  Navigator.pop(context);
                },
                child: Container(
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: kCardsColor,
                  ),
                  child: Center(
                    child: ListTile(
                      title: Text(widget.timeList[index]),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
