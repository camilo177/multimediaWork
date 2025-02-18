import 'package:clean_architecture/domain/entities/song.dart';
import 'package:clean_architecture/domain/repositories/song_repository.dart';

class GetAllSongs {
  final SongRepository repository;

  GetAllSongs(this.repository);

  Future<List<Song>> execute() async {
    return await repository.getAllSongs();
  }
}
