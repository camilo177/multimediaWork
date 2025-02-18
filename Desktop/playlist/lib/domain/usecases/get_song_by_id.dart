import 'package:clean_architecture/domain/entities/song.dart';
import 'package:clean_architecture/domain/repositories/song_repository.dart';

class GetSongById {
  final SongRepository repository;

  GetSongById(this.repository);

  Future<Song> execute(String id) async {
    return await repository.getSongById(id);
  }
}
