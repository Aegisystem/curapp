import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

/*
void main(List<String> arguments) async {
  var url = Uri.https('e9pgx4s3.directus.app', '/items/gospels',
      {'filter[date][_lte]':'2022-07-12', 'sort' : '-date', 'limit' : '1'});

  // You will wait for the response and then decode the JSON string.
  var response = await http.get(url);
  if (response.statusCode != 200) {
    print("HTTP GET RESPONSE REQUEST FAILED.");
  } else {
    var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
    String headline = jsonResponse['data'][0]['headline'];
    print('Headline: ' + headline);}
}
*/

class Data {
  var id, user_created, date_created, user_updated, date_updated, headline,
      date, media_type, audio, image, video;

  Data(this.id, this.user_created,  this.date_created, this.user_updated,
      this.date_updated, this.headline, this.date, this.media_type, this.audio,
      this.image, this.video) {
    init();
  }

  Future<void> init() async {
    var url = Uri.https('e9pgx4s3.directus.app', '/items/gospels',
        {'filter[date][_lte]':'2022-07-12', 'sort' : '-date', 'limit' : '1'});

    // You will wait for the response and then decode the JSON string.
    var response = await http.get(url);
    if (response.statusCode != 200) {
      throw new Exception("HTTP GET RESPONSE REQUEST FAILED.");
    } else {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      id            = jsonResponse['data'][0]['headline'];
      user_created  = jsonResponse['data'][0]['user_created'];
      date_created  = jsonResponse['data'][0]['date_created'];
      user_updated  = jsonResponse['data'][0]['user_updated'];
      date_updated  = jsonResponse['data'][0]['date_updated'];
      headline      = jsonResponse['data'][0]['headline'];
      date          = jsonResponse['data'][0]['date'];
      media_type    = jsonResponse['data'][0]['media_type'];
      audio         = jsonResponse['data'][0]['audio'];
      image         = jsonResponse['data'][0]['image'];
      video         = jsonResponse['data'][0]['video'];
      print(video + 'Video');
    }
  }

  get getImage {
    print('GetImage' + image);
    return image;
  }

  get basePath  {
    return 'https://e9pgx4s3.directus.app/';
  }

  Future<String> imageLink() async {
    await init();
    print('Image ' + image);
    return basePath+'assets/'+getImage;
  }
}