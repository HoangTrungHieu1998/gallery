import 'dart:convert';

import 'package:gallery/models/photo.dart';
import 'package:http/http.dart' as http;

import '../error.dart';

class ImageService{
  final http.Client client;

  ImageService({required this.client});

  Future<List<Photos>?> getImageData(int page) async{
    try{
      List<Photos>? list = [];
      final response = await client.get(
          Uri.parse(
              "https://api.unsplash.com/photos/?per_page=6&page=$page&client_id=8oqTVS8DrDwL9Qf0kH4TRj5O6gOetJR1KU7hPGOUlcg"
          ),
          headers: {
            'Content-Type':'application/json'
          }
      );
      if(response.statusCode == 200){
        List<dynamic>? jsonRaw = json.decode(response.body);
        if (jsonRaw != null && jsonRaw.isNotEmpty) {
          for (var p in jsonRaw) {
            list.add(Photos.fromJson(p));
          }
        }
        return list;
      }else{
        throw ServerException();
      }
    }catch(_){
      throw ServerException();
    }
  }

}
