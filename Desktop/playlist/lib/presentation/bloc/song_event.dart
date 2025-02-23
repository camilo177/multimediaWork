import 'package:clean_architecture/domain/entities/song.dart';

abstract class SongEvent {}

class LoadSongs extends SongEvent {}

class AddSong extends SongEvent {
  final Song song;
  AddSong(this.song);
}

class DeleteSongEvent extends SongEvent {
  final String id;
  DeleteSongEvent(this.id);
}
