class HistoryModel {
  String id;
  String userId;
  String latitude;
  String longitude;
  String datetime;

  HistoryModel(
      {this.id, this.userId, this.latitude, this.longitude, this.datetime});

  HistoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    datetime = json['datetime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['datetime'] = this.datetime;
    return data;
  }
}
