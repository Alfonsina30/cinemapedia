import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

//***provider 1 */
/// inicialment es una string vacia que cambia con el valor que se quiere buscar
final searchResultQueryProvider = StateProvider<String>((ref) => '');


//***provider 2 */
/// representacion de StateNotifier that working with ListMovie is use on widget screen
final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {

  final movieRepository = ref.read( movieRepositoryProvider );

  return SearchedMoviesNotifier(
    searchMovies: movieRepository.searchMovies, 
    ref: ref
  );
});


typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {

  final SearchMoviesCallback searchMovies;
  final Ref ref;

  SearchedMoviesNotifier({
    required this.searchMovies,
    required this.ref,
  }): super([]);


  Future<List<Movie>> searchMoviesByQuery( String query ) async{
    
    final List<Movie> movies = await searchMovies(query);
    print('SEARCH MOVIE $query $movies');
 
    ref.read(searchResultQueryProvider.notifier).update((state) => query); // update riverpod method asign new state

    state = movies;
    return movies;
  }

}






