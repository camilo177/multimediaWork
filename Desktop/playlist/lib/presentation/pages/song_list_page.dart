import 'package:clean_architecture/domain/entities/song.dart';
import 'package:clean_architecture/presentation/bloc/song_bloc.dart';
import 'package:clean_architecture/presentation/bloc/song_event.dart';
import 'package:clean_architecture/presentation/bloc/song_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class SongListPage extends StatelessWidget {
  const SongListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Songs'),
      ),
      body: BlocBuilder<SongBloc, SongState>(
        builder: (context, state) {
          if (state is SongLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SongError) {
            return Center(child: Text(state.message));
          }
          if (state is SongLoaded) {
            return ListView.builder(
              itemCount: state.songs.length,
              itemBuilder: (context, index) {
                final song = state.songs[index];
                return ListTile(
                  title: Text(song.name),
                  subtitle: Text('Artist: ${song.artist}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      context.read<SongBloc>().add(
                            DeleteSongEvent(song.id),
                          );
                    },
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No songs available'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final song = Song(
            id: const Uuid().v4(),
            name: 'New Song ${DateTime.now().millisecondsSinceEpoch}',
            artist: 'Camilo',
            album: 'Album 1',
            genre: 'Sad Music',
          );
          context.read<SongBloc>().add(AddSong(song));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
