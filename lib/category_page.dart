import 'package:flutter/material.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/department_icons.dart';
import 'package:provider/provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({this.cardDepartments, Key key}) : super(key: key);
  final List cardDepartments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorBlue,
      body: Container(
        child: ListView.builder(
          itemCount: cardDepartments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  Provider.of<CategoryData>(context, listen: false)
                      .selectCategory(cardDepartments[index]);
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
                      leading: Image.asset(
                          'images/${departmentIcons[cardDepartments[index]]}'),
                      title: Text(cardDepartments[index]),
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
