import 'package:clean_architecture/data/repositories/song_repository_impl.dart';
import 'package:clean_architecture/domain/repositories/song_repository.dart';
import 'package:clean_architecture/domain/usecases/delete_song.dart';
import 'package:clean_architecture/domain/usecases/get_all_songs.dart';
import 'package:clean_architecture/domain/usecases/save_song.dart';
import 'package:clean_architecture/presentation/bloc/song_bloc.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void initializeDependencies() {
  // Repositories
  getIt.registerLazySingleton<SongRepository>(
    () => SongRepositoryImpl(),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetAllSongs(getIt<SongRepository>()),
  );
  getIt.registerLazySingleton(
    () => SaveSong(getIt<SongRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteSong(getIt<SongRepository>()),
  );

  // BLoCs
  getIt.registerFactory(
    () => SongBloc(
      getAllSongs: getIt<GetAllSongs>(),
      saveSong: getIt<SaveSong>(),
      deleteSong: getIt<DeleteSong>(),
    ),
  );
}
