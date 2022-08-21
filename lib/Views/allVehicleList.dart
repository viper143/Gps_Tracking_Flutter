import 'package:FleetTracker/Views/reportProblem.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:FleetTracker/Controllers/dashboard.dart';
import 'package:url_launcher/url_launcher.dart';

class AllVehicleList extends StatefulWidget {
  final int initialIndex;
  AllVehicleList(this.initialIndex);
  @override
  _AllVehicleListState createState() => _AllVehicleListState();
}

class _AllVehicleListState extends State<AllVehicleList>
    with SingleTickerProviderStateMixin {
  DashBoardController _dashBoardController = Get.find();
  TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(
        length: 3, vsync: this, initialIndex: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Vehicles',
          style: TextStyle(color: Colors.black),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            height: 40,
            child: DefaultTabController(
              length: 3,
              child: TabBar(
                controller: _tabController,
                tabs: [
                  Text(
                    'All',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Online',
                    style: TextStyle(
                        color: Colors.green,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Offline',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: TabBarView(controller: _tabController, children: [
        Container(
            child: ListView.builder(
                itemCount: _dashBoardController.allVehicleDetails.length,
                itemBuilder: (context, int index) {
                  return Card(
                    elevation: 10,
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Image.asset(
                          'assets/pin_icon.png',
                          width: 40,
                          height: 40,
                        ),
                        title: Text(
                          _dashBoardController
                              .allVehicleDetails[index].FleetName,
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text("Fleet Type: " +
                                _dashBoardController
                                    .allVehicleDetails[index].FleetType),
                            SizedBox(height: 4),
                            Text("IMEI Number: " +
                                _dashBoardController
                                    .allVehicleDetails[index].FleetIMEINumber),
                            SizedBox(height: 4),
                            Text("Project Name: " +
                                _dashBoardController
                                    .allVehicleDetails[index].ProjectName),
                            SizedBox(height: 4),
                            Text("Fleet Model: " +
                                _dashBoardController
                                    .allVehicleDetails[index].FleetModel),
                          ],
                        ),
                        trailing: GestureDetector(
                          onTap: () => launch('tel:' +
                              _dashBoardController
                                  .allVehicleDetails[index].FleetPhoneNumber),
                          child: Image.asset('assets/call.png',
                              width: 30, height: 30),
                        ),
                      ),
                    ),
                  );
                })),
        Container(
            child: ListView.builder(
                itemCount: _dashBoardController.allVehicleDetails.length,
                itemBuilder: (context, int index) {
                  return _dashBoardController.allVehicleDetails[index].Status ==
                          true
                      ? Card(
                          elevation: 10,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.asset(
                                'assets/pin_icon.png',
                                width: 40,
                                height: 40,
                              ),
                              title: Text(
                                _dashBoardController
                                    .allVehicleDetails[index].FleetName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text("Fleet Type: " +
                                      _dashBoardController
                                          .allVehicleDetails[index].FleetType),
                                  SizedBox(height: 4),
                                  Text("IMEI Number: " +
                                      _dashBoardController
                                          .allVehicleDetails[index]
                                          .FleetIMEINumber),
                                  SizedBox(height: 4),
                                  Text("Project Name: " +
                                      _dashBoardController
                                          .allVehicleDetails[index]
                                          .ProjectName),
                                  SizedBox(height: 4),
                                  Text("Fleet Model: " +
                                      _dashBoardController
                                          .allVehicleDetails[index].FleetModel),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () => launch('tel:' +
                                    _dashBoardController
                                        .allVehicleDetails[index]
                                        .FleetPhoneNumber),
                                child: Image.asset('assets/call.png',
                                    width: 30, height: 30),
                              ),
                            ),
                          ),
                        )
                      : Container();
                })),
        Container(
            child: ListView.builder(
                itemCount: _dashBoardController.allVehicleDetails.length,
                itemBuilder: (context, int index) {
                  return _dashBoardController.allVehicleDetails[index].Status ==
                          false
                      ? Card(
                          elevation: 10,
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: Image.asset(
                                'assets/pin_icon.png',
                                width: 40,
                                height: 40,
                              ),
                              title: Text(
                                _dashBoardController
                                    .allVehicleDetails[index].FleetName,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 4),
                                  Text("Fleet Type: " +
                                      _dashBoardController
                                          .allVehicleDetails[index].FleetType),
                                  SizedBox(height: 4),
                                  Text("IMEI Number: " +
                                      _dashBoardController
                                          .allVehicleDetails[index]
                                          .FleetIMEINumber),
                                  SizedBox(height: 4),
                                  Text("Project Name: " +
                                      _dashBoardController
                                          .allVehicleDetails[index]
                                          .ProjectName),
                                  SizedBox(height: 4),
                                  Text("Fleet Model: " +
                                      _dashBoardController
                                          .allVehicleDetails[index].FleetModel),
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () => launch('tel:' +
                                    _dashBoardController
                                        .allVehicleDetails[index]
                                        .FleetPhoneNumber),
                                child: Image.asset('assets/call.png',
                                    width: 30, height: 30),
                              ),
                            ),
                          ),
                        )
                      : Container();
                })),
      ]),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 3,
            width: Get.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[350]),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton.extended(
                  heroTag: 'firstButton',
                  isExtended: true,
                  backgroundColor: Colors.blueGrey,
                  label: Text('Report a Problem'),
                  elevation: 0,
                  icon: Icon(Icons.report),
                  onPressed: () {
                    Get.to(ReportProblem());
                  }),
              FloatingActionButton.extended(
                  heroTag: 'secondButton',
                  isExtended: true,
                  backgroundColor: Colors.redAccent,
                  label: Text('Close'),
                  elevation: 0,
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Get.back();
                  }),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
