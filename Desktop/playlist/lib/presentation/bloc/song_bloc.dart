import 'package:clean_architecture/domain/usecases/delete_song.dart';
import 'package:clean_architecture/domain/usecases/get_all_songs.dart';
import 'package:clean_architecture/domain/usecases/save_song.dart';
import 'package:clean_architecture/presentation/bloc/song_event.dart';
import 'package:clean_architecture/presentation/bloc/song_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SongBloc extends Bloc<SongEvent, SongState> {
  final GetAllSongs getAllSongs;
  final SaveSong saveSong;
  final DeleteSong deleteSong;

  SongBloc({
    required this.getAllSongs,
    required this.saveSong,
    required this.deleteSong,
  }) : super(SongInitial()) {
    on<LoadSongs>(_onLoadSongs);
    on<AddSong>(_onAddSong);
    on<DeleteSongEvent>(_onDeleteSong);
  }

  Future<void> _onLoadSongs(
    LoadSongs event,
    Emitter<SongState> emit,
  ) async {
    emit(SongLoading());
    try {
      final songs = await getAllSongs.execute();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onAddSong(
    AddSong event,
    Emitter<SongState> emit,
  ) async {
    emit(SongLoading());
    try {
      await saveSong.execute(event.song);
      final songs = await getAllSongs.execute();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }

  Future<void> _onDeleteSong(
    DeleteSongEvent event,
    Emitter<SongState> emit,
  ) async {
    emit(SongLoading());
    try {
      await deleteSong.execute(event.id);
      final songs = await getAllSongs.execute();
      emit(SongLoaded(songs));
    } catch (e) {
      emit(SongError(e.toString()));
    }
  }
}
