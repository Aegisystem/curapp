import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

GetGospelsResponse dataFromJson(String str) => GetGospelsResponse.fromJson(json.decode(str));

class GetGospelsResponse {
  GetGospelsResponse({
    required this.items,
  });

  List<Gospel> items;

  factory GetGospelsResponse.fromJson(Map<String, dynamic> json) => GetGospelsResponse(
    items: List<Gospel>.from(json["items"].map((item) => Gospel.fromJson(item["fields"], json["includes"]["Asset"]))),
  );
}

class Gospel {
  Gospel({
    required this.headline,
    required this.date,
    required this.mediaType,
    required this.audio,
    required this.image,
  });

  String headline;
  DateTime date;
  String mediaType;
  String image;
  String audio;

  factory Gospel.fromJson(Map<String, dynamic> item, List<dynamic> assetsJson) {

    final audioAsset = assetsJson.firstWhere((element) => element["sys"]["id"] == item["audio"]["sys"]["id"]);
    final audioLink = audioAsset["fields"]["file"]["url"];

    final imageAsset = assetsJson.firstWhere((element) => element["sys"]["id"] == item["image"]["sys"]["id"]);
    final imageLink = imageAsset["fields"]["file"]["url"];

    return Gospel(
      headline: item["headline"],
      date: DateTime.parse(item["date"]),
      mediaType: item["media_type"],
      audio: audioLink,
      image: imageLink,
    );
  }
}

Future<GetGospelsResponse> getGospel() async {
  var url = Uri.https(dotenv.env['BASEPATH']??'', '${dotenv.env['ENVIRONMENT_PATH']??''}entries',
      {'access_token':dotenv.env['ACCESS_TOKEN'],'content_type':'gospels','fields.date[lte]':_getTodayDate(), 'order' : '-fields.date', 'limit' : '1'});
  final resp = await http.get(url);
  return dataFromJson(resp.body);
}

_getTodayDate() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(now);
}