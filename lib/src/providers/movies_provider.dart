import 'dart:async';
import 'dart:convert';

import 'package:movies/src/models/movie_model.dart';
import 'package:http/http.dart' as http;

class MoviesProvider {
  String _apikey = 'f48a2bbc3dda78c244fb75815cac1da3';
  String _url = 'api.themoviedb.org';
  String _language = 'en-EN';

  int _popularPage = 0;
  bool _loadingMovies = false;
  List<Movie> _popularMovies = new List();
  final _popularMoviesStream = StreamController<List<Movie>>.broadcast();

  Function(List<Movie>) get popularMoviesSink => _popularMoviesStream.sink.add;

  Stream<List<Movie>> get popularMoviesStream => _popularMoviesStream.stream;

  void disposeStreams() {
    _popularMoviesStream?.close();
  }

  Future<List<Movie>> _processRespond(Uri url) async {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    final movies = new Movies.fromJsonList(decodedData['results']);

    return movies.items;
  }

  Future<List<Movie>> getAtTheaters() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apikey,
      'f48a2bbc3dda78c244fb75815cac1da3': _language,
    });
    return await _processRespond(url);
  }

  Future<List<Movie>> getPopular() async {
    if (_loadingMovies) return [];
    _loadingMovies = true;
    _popularPage++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apikey,
      'f48a2bbc3dda78c244fb75815cac1da3': _language,
      'page': _popularPage.toString(),
    });

    final response = await _processRespond(url);

    _popularMovies.addAll(response);
    popularMoviesSink(_popularMovies);

    _loadingMovies = false;
    return response;
  }
}
