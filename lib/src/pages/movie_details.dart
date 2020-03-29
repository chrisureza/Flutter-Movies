import 'package:flutter/material.dart';
import 'package:movies/src/models/cast_model.dart';
import 'package:movies/src/models/movie_info_model.dart.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: Center(
        child: CustomScrollView(
          slivers: <Widget>[
            _createAppbar(movie),
            SliverList(
              delegate: SliverChildListDelegate([
                SizedBox(height: 10.0),
                _posterTitle(context, movie),
                SizedBox(height: 15.0),
                _showMovieInfo(context, movie),
                _description(context, movie),
                _showCast(context, movie),
              ]),
            )
          ],
        ),
      ),
    );
  }

  Widget _createAppbar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.yellow[800],
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Container(
          child: Text(
            movie.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        background: FadeInImage(
          placeholder: AssetImage('assets/imgs/loading.gif'),
          image: NetworkImage(movie.getBackdropImg()),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(
                  movie.getPosterImg(),
                ),
                height: 150.0,
              ),
            ),
          ),
          SizedBox(
            width: 20.0,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  movie.title,
                  style: Theme.of(context).textTheme.title,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  movie.originalTitle,
                  style: Theme.of(context).textTheme.subhead,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.redAccent[200],
                  ),
                  Text(
                    movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.subhead,
                  ),
                ]),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _description(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Overview:',
            style: Theme.of(context).textTheme.subtitle,
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            movie.overview,
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _showCast(BuildContext context, Movie movie) {
    final moviesProvider = new MoviesProvider();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Cast:',
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        FutureBuilder(
          future: moviesProvider.getCast(movie.id.toString()),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return _castPageView(snapshot.data);
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ],
    );
  }

  Widget _castPageView(List<Actor> cast) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1,
        ),
        itemCount: cast.length,
        itemBuilder: (context, int i) => _actorCard(cast[i]),
      ),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
        child: Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child: FadeInImage(
            image: NetworkImage(actor.getActorImg()),
            placeholder: AssetImage('assets/imgs/no-image.jpg'),
            height: 150.0,
            width: 100.0,
            fit: BoxFit.cover,
          ),
        ),
        Text(
          actor.name,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ));
  }

  Widget _showMovieInfo(BuildContext context, Movie movie) {
    final moviesProvider = new MoviesProvider();

    return FutureBuilder(
      future: moviesProvider.getMovieInfo(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<MovieInfo> snapshot) {
        if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _showGenres(context, snapshot),
              SizedBox(
                height: 10.0,
              ),
              _showReleaseDate(context, snapshot),
              SizedBox(
                height: 15.0,
              ),
              _showRuntime(context, snapshot),
            ],
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _showGenres(BuildContext context, AsyncSnapshot<MovieInfo> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Text(
            'Genres:',
            style: Theme.of(context).textTheme.subtitle,
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          scrollDirection: Axis.horizontal,
          child: _genresTagsRow(snapshot),
        ),
      ],
    );
  }

  Widget _genresTagsRow(AsyncSnapshot<MovieInfo> snapshot) {
    return Row(
      children: snapshot.data.genres
          .map((genre) => Container(
                margin: EdgeInsets.only(
                  right: 8.0,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 4.0,
                      ),
                      color: Colors.amber[700],
                      child: Text(
                        genre['name'],
                        style: TextStyle(color: Colors.grey[100]),
                      )),
                ),
              ))
          .toList(),
    );
  }

  Widget _showRuntime(BuildContext context, AsyncSnapshot<MovieInfo> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(children: <Widget>[
            Text(
              'Runtime: ',
              style: Theme.of(context).textTheme.subtitle,
            ),
            Text(
              '${snapshot.data.runtime} min',
            ),
          ]),
        ),
      ],
    );
  }

  Widget _showReleaseDate(
      BuildContext context, AsyncSnapshot<MovieInfo> snapshot) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20.0),
          child: Row(children: <Widget>[
            Text(
              'Release date: ',
              style: Theme.of(context).textTheme.subtitle,
            ),
            Text(
              snapshot.data.releaseDate.toString(),
            ),
          ]),
        ),
      ],
    );
  }
}
