import 'package:gallery/models/Urls.dart';

class Photos {
  String? id;
  String? createdAt;
  String? color;
  Urls? urls;

  Photos({this.id, this.createdAt, this.color, this.urls});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(
      id: json['id'],
      createdAt: json['created_at']??"",
      color: json['color']??"",
      urls: json['urls'] != null ? Urls.fromJson(json['urls']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['color'] = color;
    data['created_at'] = createdAt;
    data['id'] = id;
    if (urls != null) {
      data['urls'] = urls!.toJson();
    }
    return data;
  }
}
