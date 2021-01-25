import 'package:cloud_firestore/cloud_firestore.dart';
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
        locationfilterd = _locationList;
        isSearching = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getlocationlist();

    locationlist = _locations;
    locationfilterd = _locations;

    searchController.addListener(() {
      filterLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.blue[50],
                      prefixIcon: Icon(
                        Icons.search,
                        color: kPrimaryColorBlue,
                      ),
                      hintText: 'search',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              locationfilterd.isNotEmpty
                  ? Container(
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
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_off,
                            size: 50.0,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            'No More Locations.',
                            style: TextStyle(
                                color: Colors.black87, fontSize: 16.0),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
