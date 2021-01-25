import 'package:flutter/cupertino.dart';

class HospitalCardDetails {
  final String name;
  final String cost;
  final String imageUrl;
  final List<dynamic> departments;
  final List time;
  final String location;

  HospitalCardDetails({
    @required this.name,
    @required this.imageUrl,
    @required this.cost,
    @required this.location,
    @required this.departments,
    @required this.time,
  });

  String getHospitalCardItemName() {
    return name;
  }

  String getHospitalCardItemImageUrl() {
    return imageUrl;
  }

  String getHospitalCardItemCost() {
    return cost;
  }

  String getHospitalCardItemLocation() {
    return location;
  }

  List<dynamic> getHospitalCardItemDepartments() {
    return departments;
  }

  List getHospitalCardItemTime() {
    return time;
  }
}
