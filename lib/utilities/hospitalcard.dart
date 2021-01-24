import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'file:///E:/Projects/Medifly/lib/bookingscreen.dart';
import 'package:medifly/utilities/constants.dart';

class HospitalCard extends StatefulWidget {
  const HospitalCard({
    this.textHeight,
    this.departments,
    this.onPressed,
    this.title,
    this.amount,
    this.location,
    this.image,
    this.time,
    Key key,
  }) : super(key: key);
  final List departments;
  final String title;
  final String amount;
  final Function onPressed;
  final String location;
  final String image;
  final List time;
  final double textHeight;
  @override
  _HospitalCardState createState() => _HospitalCardState();
}

class _HospitalCardState extends State<HospitalCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 5.0),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Container(
            decoration: BoxDecoration(
              color: kCardsColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Container(
                    child:
                        Image.network('${widget.image}', fit: BoxFit.cover) ??
                            Container(
                              child: CircularProgressIndicator(),
                            ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${widget.title}',
                          maxLines: 1,
                          softWrap: false,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: widget.textHeight),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Container(
                                child: Text(
                                  'Address ${widget.location} on the way of gude masdh ahuisdhau',
                                  maxLines: 2,
                                  softWrap: false,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                '\u{20B9} ${widget.amount}',
                                style: TextStyle(
                                    color: kRedButton,
                                    fontSize: widget.textHeight * 0.9),
                              ),
                            ),
                          ],
                        ),
                      ],
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
