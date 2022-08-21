import 'package:flutter/material.dart';

class ReportProblem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          'Report A Problem',
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 6),
            TextFormField(
              decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            SizedBox(height: 20),
            TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: 'Description',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
          ],
        ),
      ),
      bottomSheet: BottomSheet(
        onClosing: () {},
        builder: (context) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton.icon(
                      elevation: 0,
                      color: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.call,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Call',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: RaisedButton.icon(
                      elevation: 0,
                      color: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {},
                      icon: Icon(
                        Icons.report,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Send Report',
                        style: TextStyle(color: Colors.white),
                      )),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
