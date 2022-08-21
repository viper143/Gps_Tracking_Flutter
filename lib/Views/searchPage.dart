import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:FleetTracker/Controllers/editVehicle.dart';
import 'package:FleetTracker/Controllers/search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchPage extends SearchDelegate<String> {
  DashBoardController _dashBoardController = Get.find();
  SearchController _searchController = Get.find();
  VehicleEditController _vehicleEditController = Get.find();
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  final List searchQueries = List();

  final List recentSearchQueries = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> _searchList = List();
    _dashBoardController.allVehicleDetails.forEach((element) {
      _searchList.add(element.FleetIMEINumber);
      _searchList.add(element.FleetName.toLowerCase());
    });

    final displayList = query.isEmpty
        ? recentSearchQueries
        : _searchList
            .where((element) => element.startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
      itemCount: displayList.length,
      itemBuilder: (context, index) => ListTile(
          onTap: () {
            _searchController.currentVehicleSearchedName.value =
                displayList[index];
            _vehicleEditController.imeiNumber.value =
                _searchController.currentVehicleSearchedName.value;
            _dashBoardController.changeViewtoIndividualMap();
            _dashBoardController.currentView.value = false;
            Get.back();
          },
          leading: Icon(Icons.search),
          title: RichText(
              text: TextSpan(
                  text: displayList[index].substring(0, query.length),
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                  children: [
                TextSpan(
                    text: displayList[index].substring(query.length),
                    style: TextStyle(color: Colors.grey, fontSize: 16))
              ]))),
    );
  }
}
