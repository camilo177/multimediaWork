import 'package:clean_architecture/data/repositories/song_repository_impl.dart';
import 'package:clean_architecture/domain/usecases/delete_song.dart';
import 'package:clean_architecture/domain/usecases/get_all_songs.dart';
import 'package:clean_architecture/domain/usecases/save_song.dart';
import 'package:clean_architecture/presentation/bloc/song_bloc.dart';
import 'package:clean_architecture/presentation/bloc/song_event.dart';
import 'package:clean_architecture/presentation/pages/song_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create instances of dependencies
    final songRepository = SongRepositoryImpl();
    final getAllSongs = GetAllSongs(songRepository);
    final saveSong = SaveSong(songRepository);
    final deleteSong = DeleteSong(songRepository);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify UCC version',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: false,
      ),
      home: BlocProvider(
        create: (context) => SongBloc(
          getAllSongs: getAllSongs,
          saveSong: saveSong,
          deleteSong: deleteSong,
        )..add(LoadSongs()),
        child: const SongListPage(),
      ),
    );
  }
}
