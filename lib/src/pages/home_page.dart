import 'package:flutter/material.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';

class HomePage extends StatelessWidget {
  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {
    moviesProvider.getPopular();

    return Scaffold(
      appBar: AppBar(
          title: Text('Monday Movies'),
          backgroundColor: Colors.yellow[800],
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
            PopupMenuButton(
              itemBuilder: (BuildContext context) {
                return [
                  // PopupMenuItem(
                  //   value: 'toogleTvShows',
                  //   child: Text('See TV Shows'),
                  // ),
                  // PopupMenuItem(
                  //   value: 'aboutPage',
                  //   child: Text('About Page'),
                  // ),
                  PopupMenuItem(
                    value: 'about',
                    child: Text('About'),
                  ),
                ];
              },
              onSelected: (result) {
                switch (result) {
                  case 'about':
                    Navigator.pushNamed(context, 'about');
                    break;
                }
              },
            ),
          ]),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swiperCards(),
            _footer(context),
          ],
        ),
      ),
    );
  }

  Widget _swiperCards() {
    return FutureBuilder(
      future: moviesProvider.getAtTheaters(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 20.0),
                child: Text(
                  'Now at theaters:',
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              CardSwiper(
                movies: snapshot.data,
              ),
            ],
          );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Popular:',
                style: Theme.of(context).textTheme.subhead,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            StreamBuilder(
              stream: moviesProvider.popularMoviesStream,
              // initialData: InitialData,
              builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
                if (snapshot.hasData) {
                  return MovieHorizontal(
                    movies: snapshot.data,
                    nextPage: moviesProvider.getPopular,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ]),
    );
  }
}
