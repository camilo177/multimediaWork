import 'package:clean_architecture/domain/repositories/song_repository.dart';

class DeleteSong {
  final SongRepository repository;

  DeleteSong(this.repository);

  Future<void> execute(String id) async {
    await repository.deleteSong(id);
  }
}
