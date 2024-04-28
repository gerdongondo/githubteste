class Album {
  int id;
  String title;
  String userId;

  Album({required this.id, required this.title, required this.userId});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(id: json['id'], title: json['title'], userId: json['userId']);
  }
}
