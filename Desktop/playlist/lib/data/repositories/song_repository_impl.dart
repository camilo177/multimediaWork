import 'package:clean_architecture/domain/entities/song.dart';
import 'package:clean_architecture/domain/repositories/song_repository.dart';

class SongRepositoryImpl implements SongRepository {
  final List<Song> _songs = [];

  @override
  Future<List<Song>> getAllSongs() async {
    // Simulating network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _songs;
  }

  @override
  Future<Song> getSongById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _songs.firstWhere(
      (song) => song.id == id,
      orElse: () => throw Exception('Song not found'),
    );
  }

  @override
  Future<void> saveSong(Song song) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final index = _songs.indexWhere((s) => s.id == song.id);
    if (index >= 0) {
      _songs[index] = song;
    } else {
      _songs.add(song);
    }
  }

  @override
  Future<void> deleteSong(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _songs.removeWhere((song) => song.id == id);
  }
}
