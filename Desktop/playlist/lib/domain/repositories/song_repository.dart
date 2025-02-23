import 'package:clean_architecture/domain/entities/song.dart';

abstract class SongRepository {
  Future<List<Song>> getAllSongs();
  Future<Song> getSongById(String id);
  Future<void> saveSong(Song song);
  Future<void> deleteSong(String id);
}
