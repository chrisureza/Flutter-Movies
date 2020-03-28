import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/movie_model.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;

  CardSwiper({
    @required this.movies,
  });

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.only(top: 10.0),
      height: _screenSize.height * 0.55,
      child: Swiper(
        itemCount: movies.length,
        // pagination: new SwiperPagination(),
        // control: new SwiperControl(),
        itemWidth: _screenSize.width * 0.7,
        layout: SwiperLayout.STACK,
        itemBuilder: (BuildContext context, int index) =>
            _card(context, movies[index]),
      ),
    );
  }

  Widget _card(BuildContext context, Movie movie) {
    movie.uniqueId = '${movie.id}-card';
    final card = Hero(
      tag: movie.uniqueId,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: FadeInImage(
          placeholder: AssetImage('assets/imgs/no-image.jpg'),
          image: NetworkImage(movie.getPosterImg()),
          fit: BoxFit.cover,
        ),
      ),
    );

    return GestureDetector(
      child: card,
      onTap: () {
        Navigator.pushNamed(context, 'detail', arguments: movie);
      },
    );
  }
}
