class Book {
  final String title;
  final List<String> authors;
  final String coverImageUrl;
  final String downloadUrl;

  Book({required this.title, required this.authors, required this.coverImageUrl, required this.downloadUrl});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      authors: List<String>.from(json['authors']?.map((author) => author['name']) ?? []),
      coverImageUrl: json['formats']['image/jpeg'] ?? '', // Cover image URL
      downloadUrl: json['formats']['application/octet-stream'] ?? '', // Download URL
    );
  }
}