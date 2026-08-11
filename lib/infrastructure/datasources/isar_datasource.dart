import 'package:cinemapedia/domain/datasources/local_storage_datasource.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';



class IsarDatasource extends LocalStorageDatasource {
  
  late Future<Isar> db;

  IsarDatasource(){
    db = openDB();
  }


  Future<Isar> openDB() async {

    if ( Isar.instanceNames.isEmpty ) {

final dir = await getApplicationDocumentsDirectory();
      
      return await Isar.open(
        
        [movieSchema], 
        //name: 'hi',
        inspector: true,
         directory: dir.path);
        //Isar.defaultName );
    }

    return Future.value(Isar.getInstance());
  }


  @override
  Future<bool> isMovieFavorite(int movieId) async {
    final isar = await db;

    final Movie? isFavoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movieId)
      .findFirst();

    return isFavoriteMovie != null;
  }

  @override
  Future<void> toggleFavorite(Movie movie) async {
    
    final isar = await db;

    final favoriteMovie = await isar.movies
      .filter()
      .idEqualTo(movie.id)
      .findFirst();

    if ( favoriteMovie != null ) {
      // Borrar
      isar.writeTxnSync(() => isar.movies.deleteSync( favoriteMovie.isarId! ));
      return;
    }

    // Insertar
    isar.writeTxnSync(() => isar.movies.putSync(movie));

  }

  @override
  Future<List<Movie>> loadMovies({int limit = 10, offset = 0}) async {
    
    //TODO: resolver esta excepcion porque cuando se va a la pagina favoritos el codigo se friza
    final isar = await db;

  List lista = [];
  lista.where((element) => false);

    return isar.movies.where()
      .offset(offset)
      .limit(limit)
      .findAll() ;

      
  }

}