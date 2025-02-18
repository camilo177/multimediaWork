import 'package:clean_architecture/domain/entities/song.dart';
import 'package:clean_architecture/domain/repositories/song_repository.dart';

class SaveSong {
  final SongRepository repository;

  SaveSong(this.repository);

  Future<void> execute(Song song) async {
    await repository.saveSong(song);
  }
}
