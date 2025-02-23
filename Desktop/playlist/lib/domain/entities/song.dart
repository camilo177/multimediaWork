class Song {
  final String id;
  final String name;
  final String artist;
  final String album;
  final String genre;
  
  Song({
    required this.id,
    required this.name,
    required this.artist,
    required this.album,
    required this.genre,
  });

  Song copyWith({
    String? id,
    String? name,
    String? artist,
    String? album,
    String? genre,
  }) {
    return Song(
      id: id ?? this.id,
      name: name ?? this.name,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      genre: genre ?? this.genre,
    );
  }
}
