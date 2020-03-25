import 'dart:convert';

import 'package:movies/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apikey = 'f48a2bbc3dda78c244fb75815cac1da3';
  String _url = 'api.themoviedb.org';
  String _language = 'en-EN';

  Future<List<Movie>> getAtTheaters() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'f48a2bbc3dda78c244fb75815cac1da3': _language,
    });

    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }
}
