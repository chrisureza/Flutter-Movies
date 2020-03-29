import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class DataSearch extends SearchDelegate {
  final moviesProvider = new MoviesProvider();

  // final movies = [
  //   'Spiderman',
  //   'Capitan America',
  //   'Spiderman2',
  //   'Capitan America2',
  //   'Spiderman3',
  //   'Capitan America3'
  // ];

  // final recentMovies = ['Spiderman', 'Capitan America'];

  @override
  List<Widget> buildActions(BuildContext context) {
    // actions of the appbar (cancel, close, etc)
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // like the icon to appear at start
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // create the resulst to show
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions that appear when user write down

    if (query.isEmpty) return Container();

    return FutureBuilder(
      future: moviesProvider.searchMovies(query),
      builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
        if (snapshot.hasData) {
          final movies = snapshot.data;

          return ListView(
            children: movies.map((movie) {
              return ListTile(
                leading: FadeInImage(
                  placeholder: AssetImage('assets/imgs/no-image.jpg'),
                  image: NetworkImage(
                    movie.getPosterImg(),
                  ),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(
                  movie.title,
                ),
                subtitle: Text(
                  movie.overview,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  close(context, null);
                  movie.uniqueId = '';
                  Navigator.pushNamed(context, 'detail', arguments: movie);
                },
              );
            }).toList(),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  //   @override
  // Widget buildSuggestions(BuildContext context) {
  //   // Suggestions that appear when user write down
  //   final suggestedList = (query.isEmpty)
  //       ? recentMovies
  //       : movies
  //           .where(
  //               (movie) => movie.toLowerCase().startsWith(query.toLowerCase()))
  //           .toList();

  //   return ListView.builder(
  //     itemCount: suggestedList.length,
  //     itemBuilder: (context, index) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(suggestedList[index]),
  //         onTap: () {},
  //       );
  //     },
  //   );
  // }
}
