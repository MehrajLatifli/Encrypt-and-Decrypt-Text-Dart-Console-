class Text<T extends String, T2 extends DateTime> {
  T? id;
  T? text;
  T2? releaseDate;

  T? get getId => this.id;

  void setId(T? id) {
    this.id = id;
  }

  T? get getText => this.text;

  void setText(T? text) {
    this.text = text;
  }

  T2? get getReleaseDate => this.releaseDate;

  void setReleaseDate(T2? releaseDate) {
    this.releaseDate = releaseDate;
  }

  Text(T id, T text, T2 releaseDate) {
    this.id = id;
    this.text = text;
    this.releaseDate = releaseDate;
  }

  factory Text.fromJson(Map<String, dynamic> json) {
    return Text(
      json['id']! as T,
      json['text']! as T,
      DateTime.parse(json['releaseDate']! as String) as T2,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'releaseDate': releaseDate?.toIso8601String(),
    };
  }
}
