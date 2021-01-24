import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medifly/utilities/categories_data.dart';
import 'package:medifly/utilities/categoryhospital.dart';
import 'package:medifly/utilities/constants.dart';
import 'package:medifly/utilities/department_icons.dart';
import 'package:medifly/utilities/pageheader.dart';
import 'package:provider/provider.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({this.cardDepartments, Key key}) : super(key: key);
  final List cardDepartments;

  @override
  _CategoriesWidgetState createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColorBlue,
      body: Container(
        child: ListView.builder(
          itemCount: widget.cardDepartments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: GestureDetector(
                onTap: () {
                  Provider.of<CategoryData>(context, listen: false)
                      .selectCategory(widget.cardDepartments[index]);
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
                          'images/${departmentIcons[widget.cardDepartments[index]]}'),
                      title: Text(
                        widget.cardDepartments[index],
                      ),
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

class CategoryPage extends StatefulWidget {
  static String id = 'CategoryPage';

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            PageHeader(title: "Categories"),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('categories')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final categoryCardData = snapshot.data.docs;
                  List<CategoryCard> categoryCards = [];
                  for (var card in categoryCardData) {
                    print('${card.data()['category']}');
                    final categoryCard = CategoryCard(
                      cardTitle: '${card.data()['category']}',
                    );
                    categoryCards.add(categoryCard);
                  }
                  return categoryCards.isNotEmpty
                      ? Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: 8.0,
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: GridView.count(
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              children: categoryCards,
                            ),
                          ),
                        )
                      : Container();
                }
                return CircularProgressIndicator(
                    // valueColor: kPrimaryColorBlue,
                    );
              },
            )
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String cardTitle;
  final Function onTap;
  CategoryCard({
    this.cardTitle,
    this.onTap,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryHospital(
                category: cardTitle,
              ),
            ),
          );
        },
        child: Container(
          width: 200,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade50,
                blurRadius: 15,
                offset: Offset(0, 5),
                spreadRadius: 1.5,
              )
            ],
            color: kCardsColor,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                child: Container(
                  width: 130,
                  child: Image.asset(
                    'images/${departmentIcons['$cardTitle']}',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                '$cardTitle',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
