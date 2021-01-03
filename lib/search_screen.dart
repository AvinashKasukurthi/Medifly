import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medifly/locations_card_screen.dart';
import 'package:medifly/utilities/constants.dart';

FirebaseFirestore locationRef = FirebaseFirestore.instance;

class SearchScreen extends StatefulWidget {
  static String id = 'search screen';
  SearchScreen({this.onPressed});
  Function onPressed;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool isSearching;
  List<String> locationlist = [];
  List<String> _locations = [];
  List<String> locationfilterd = [];
  TextEditingController searchController = TextEditingController();

  void getlocationlist() async {
    await for (var snapshots
        in locationRef.collection('hospital_data').snapshots()) {
      for (var locationData in snapshots.docs) {
        var location = locationData.data()['location'];
        if (_locations.contains(location) == false) {
          setState(() {
            _locations.add(location);
          });
        }
      }
      print(locationlist);
    }
  }

  void filterLocation() {
    List<String> _locationList = [];
    _locationList.addAll(locationlist);
    if (searchController.text.isNotEmpty) {
      isSearching = true;
      _locationList.retainWhere((city) {
        String searchTerm = searchController.text.toLowerCase();
        String cityName = city.toLowerCase();
        return cityName.contains(searchTerm);
      });
      setState(() {
        locationfilterd = _locationList;
      });
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getlocationlist();

    locationlist = _locations;

    searchController.addListener(() {
      filterLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.search,
                    color: kPrimaryColorBlue,
                  ),
                  hintText: 'search',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: kPrimaryColorBlue)),
                ),
              ),
            ),
          ),
          Container(
            child: Expanded(
              child: ListView.builder(
                itemCount: isSearching == true
                    ? locationfilterd.length
                    : locationlist.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LocationCardScreen(
                              location: isSearching == true
                                  ? locationfilterd[index]
                                  : locationlist[index],
                            ),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 2),
                      child: Container(
                        decoration: BoxDecoration(
                          color: kCardsColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: Icon(
                            Icons.location_on,
                            color: kPrimaryColorBlue,
                          ),
                          title: Text(isSearching == true
                              ? locationfilterd[index]
                              : locationlist[index]),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class HospitalslistSearch extends SearchDelegate<Hospitalslist> {
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: Icon(Icons.clear),
//         onPressed: () {
//           query = "";
//         },
//       )
//     ];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: Icon(Icons.arrow_back),
//         onPressed: () {
//           close(context, null);
//         });
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     return Center(
//       child: Text(
//         query,
//         style: TextStyle(fontSize: 20.0),
//       ),
//     );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     List<Hospitalslist> myHospital;
//     if (query.isEmpty) {
//       myHospital = loadhospitalslist();
//     } else if (query.isNotEmpty) {
//       myHospital = loadhospitalslist()
//           .where((p) =>
//               (p.category.toLowerCase().startsWith(query.toLowerCase())) ||
//               (p.title.toLowerCase().startsWith(query.toLowerCase())))
//           .toList();
//     } else {
//       myHospital = loadhospitalslist()
//           .where((p) => p.title.toLowerCase().startsWith(query.toLowerCase()))
//           .toList();
//     }

//     return myHospital.isEmpty
//         ? Text(
//             'No Results Found...',
//             style: TextStyle(fontSize: 20.0),
//           )
//         : ListView.builder(
//             itemBuilder: (context, index) {
//               final Hospitalslist hospitalslistItem = myHospital[index];
//               return ListTile(
//                 onTap: () {
//                   showResults(context);
//                 },
//                 title: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       hospitalslistItem.title,
//                       style: TextStyle(fontSize: 20.0),
//                     ),
//                     Text(
//                       hospitalslistItem.category,
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                     Divider()
//                   ],
//                 ),
//               );
//             },
//             itemCount: myHospital.length,
//           );
//   }
// }

// class Hospitalslist {
//   final String title;
//   final String category;
//   Hospitalslist({this.title, this.category});
// }

// List<Hospitalslist> loadhospitalslist() {
//   var hl = <Hospitalslist>[
//     Hospitalslist(title: 'sai hospital', category: 'Tanuku'),
//     Hospitalslist(title: 'sss hospital', category: 'Velpuru'),
//     Hospitalslist(title: 'RR hospital', category: 'Vizag'),
//     Hospitalslist(title: 'YS hospital', category: 'Eluru'),
//     Hospitalslist(title: 'Gi hospital', category: 'Tanuku'),
//     Hospitalslist(title: 'JK hospital', category: 'Tanuku'),
//   ];
//   return hl;
// }
