import 'package:gallery/constant.dart';

class Urls {
    String? full;
    String? raw;
    String? regular;
    String? small;
    String? small_s3;
    String? thumb;

    Urls({this.full, this.raw, this.regular, this.small, this.small_s3, this.thumb});

    factory Urls.fromJson(Map<String, dynamic> json) {
        return Urls(
            full: json['full']??Constant.cacheImage,
            raw: json['raw']??Constant.cacheImage,
            regular: json['regular']??Constant.cacheImage,
            small: json['small']??Constant.cacheImage,
            small_s3: json['small_s3']??Constant.cacheImage,
            thumb: json['thumb']??Constant.cacheImage,
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = <String, dynamic>{};
        data['full'] = full;
        data['raw'] = raw;
        data['regular'] = regular;
        data['small'] = small;
        data['small_s3'] = small_s3;
        data['thumb'] = thumb;
        return data;
    }
}