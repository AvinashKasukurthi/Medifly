import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:medifly/utilities/bookingscreen.dart';
import 'package:medifly/utilities/constants.dart';

class HospitalCard extends StatefulWidget {
  const HospitalCard({
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
  @override
  _HospitalCardState createState() => _HospitalCardState();
}

class _HospitalCardState extends State<HospitalCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Card(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
          elevation: 6.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0)),
                  child: Image.network('${widget.image}', fit: BoxFit.cover),
                ),
              ),
              Expanded(
                flex: 2,
                child: ListTile(
                  trailing: Text(
                    '\u{20B9} ${widget.amount}',
                    style: TextStyle(color: kRedButton),
                  ),
                  title: Text(
                    '${widget.title}',
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Address ${widget.location} on the way of gudemasdhahuisdhau',
                        maxLines: 2,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  // contentPadding: EdgeInsets.all(10.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
