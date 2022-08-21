class DetailModel {
  String FleetName;
  String FleetIMEINumber;
  String FleetPhoneNumber;
  String CompanyID;
  bool Status;
  String FleetType;
  String FleetModel;
  bool UnderMaintainence;
  String ProjectName;
  String Latitude;
  String Longitude;
  String TimeStamp;

  DetailModel(
    this.FleetName,
    this.FleetIMEINumber,
    this.FleetPhoneNumber,
    this.FleetType,
    this.CompanyID,
    this.Status,
    this.FleetModel,
    this.UnderMaintainence,
    this.ProjectName,
    this.Latitude,
    this.Longitude,
    this.TimeStamp,
  );

  DetailModel.fromJson(json)
      : FleetName = json['fleetName'],
        FleetPhoneNumber = json['fleetPhoneNumber'],
        CompanyID = json['companyID'],
        FleetType = json['fleetType'],
        FleetIMEINumber = json['fleetIMEINumber'],
        Status = json['status'],
        FleetModel = json['fleetModel'],
        UnderMaintainence = json['underMaintainence'],
        ProjectName = json['projectName'],
        Latitude = json['latitude'],
        Longitude = json['longitude'],
        TimeStamp = json['timestamp'];
}
