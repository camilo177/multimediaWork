import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clean_architecture/presentation/bloc/song_bloc.dart';
import 'package:clean_architecture/presentation/bloc/song_event.dart';
import 'package:clean_architecture/presentation/pages/song_list_page.dart';
import 'package:clean_architecture/injection.dart'; 

void main() {
  initializeDependencies(); 
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Spotify UCC version',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: false,
      ),
      home: BlocProvider(
        create: (context) => getIt<SongBloc>()..add(LoadSongs()), 
        child: const SongListPage(),
      ),
    );
  }
}
