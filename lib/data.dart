import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

GetGospelsResponse dataFromJson(String str) => GetGospelsResponse.fromJson(json.decode(str));

String dataToJson(GetGospelsResponse data) => json.encode(data.toJson());

class GetGospelsResponse {
  GetGospelsResponse({
    required this.data,
  });

  List<Gospel> data;

  factory GetGospelsResponse.fromJson(Map<String, dynamic> json) => GetGospelsResponse(
    data: List<Gospel>.from(json["data"].map((x) => Gospel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Gospel {
  Gospel({
    required this.id,
    required this.headline,
    required this.date,
    required this.mediaType,
    required this.audio,
    required this.image,
  });

  String id;
  String headline;
  DateTime date;
  String mediaType;
  String audio;
  String image;

  factory Gospel.fromJson(Map<String, dynamic> json) => Gospel(
    id: json["id"],
    headline: json["headline"],
    date: DateTime.parse(json["date"]),
    mediaType: json["media_type"],
    audio: json["audio"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "headline": headline,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "media_type": mediaType,
    "audio": audio,
    "image": image,
  };
}
Future<GetGospelsResponse> getGospel() async {
  var url = Uri.https(dotenv.env['BASEPATH']??'', '/items/gospels',
      {'filter[date][_lte]':_getTodayDate(), 'sort' : '-date', 'limit' : '1'});
  final resp = await http.get(url);
  return dataFromJson(resp.body);
}

_getTodayDate() {
  var now = DateTime.now();
  var formatter = DateFormat('yyyy-MM-dd');
  return formatter.format(now);
}