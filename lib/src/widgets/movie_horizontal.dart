import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';

class MovieHorizontal extends StatelessWidget {
  final List<Movie> movies;
  final Function nextPage;

  MovieHorizontal({
    @required this.movies,
    @required this.nextPage,
  });

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3,
  );

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        nextPage();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemCount: movies.length,
        itemBuilder: (BuildContext context, int i) =>
            _card(context, movies[i], _screenSize),
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie, Size _screenSize) {
    movie.uniqueId = '${movie.id}-horizontal';
    final card = Container(
      margin: EdgeInsets.only(right: 15.0),
      child: Column(children: <Widget>[
        Hero(
          tag: movie.uniqueId,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(movie.getPosterImg()),
              placeholder: AssetImage('assets/imgs/no-image.jpg'),
              fit: BoxFit.cover,
              height: _screenSize.height * 0.17,
            ),
          ),
        ),
        SizedBox(
          height: 4.0,
        ),
        Container(
          child: Text(
            movie.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          ),
        ),
      ]),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }

  // List<Widget> _cards(Size _screenSize) {
  //   return movies.map((movie) {
  //     return Container(
  //       margin: EdgeInsets.only(right: 15.0),
  //       child: Column(children: <Widget>[
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(20.0),
  //           child: FadeInImage(
  //             image: NetworkImage(movie.getPosterImg()),
  //             placeholder: AssetImage('assets/imgs/no-image.jpg'),
  //             fit: BoxFit.cover,
  //             height: _screenSize.height * 0.17,
  //           ),
  //         ),
  //         SizedBox(
  //           height: 4.0,
  //         ),
  //         Container(
  //           child: Text(
  //             movie.title,
  //             overflow: TextOverflow.ellipsis,
  //           ),
  //         ),
  //       ]),
  //     );
  //   }).toList();
  // }
}
