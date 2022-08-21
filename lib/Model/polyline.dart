class PolyLineModel {
  String Latitude;
  String Longitude;
  String TimeStamp;

  PolyLineModel(
    this.Latitude,
    this.Longitude,
    this.TimeStamp,
  );

  PolyLineModel.fromJson(Map<String, dynamic> json)
      : Latitude = json['latitude'],
        Longitude = json['longitude'],
        TimeStamp = json['timestamp'];
}