
enum ContentType { document, image, video, recording, file }

ContentType contentTypeFromString(String type) {
  switch (type) {
    case 'DOC':
      return ContentType.document;
    case 'IMG':
      return ContentType.image;
    case 'VIDEO':
      return ContentType.video;
    case 'AUDIO':
      return ContentType.recording;
    case 'FILE':
      return ContentType.file;
    default:
      return ContentType.file;
  }
}

class MaterialModel {
  final int id;
  final ContentType type;
  final String fileUrl;

  MaterialModel({required this.id, required this.type, required this.fileUrl});

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      type: contentTypeFromString(json['materialType']),
      fileUrl: json['fileUrl'],
    );
  }
}

class LessonContent {
  final int id;
  final String title;
  final List<String> notes;
  final List<MaterialModel> materials;
  final List<int> completedUserIds;

  LessonContent({
    required this.id,
    required this.title,
    required this.notes,
    required this.materials,
    required this.completedUserIds,
  });

  factory LessonContent.fromJson(Map<String, dynamic> json) {
    return LessonContent(
      id: json['id'],
      title: json['name'],
      notes: (json['notes'] as List?)?.map((e) => e.toString()).toList() ?? [],
      materials: (json['Materials'] as List)
          .map((m) => MaterialModel.fromJson(m))
          .toList(),
      completedUserIds: (json['CompletedLessons'] as List?)?.map((e) => e['userId'] as int).toList() ?? [],
    );
  }

  // Helper: is this lesson completed by the current user?
  bool isCompleted(int userId) => completedUserIds.contains(userId);

  // Helper: join notes for display
  String get notesDisplay => notes.join('\n');
}

class SectionModel {
  final int id;
  final String name;
  final String description;

  SectionModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory SectionModel.fromJson(Map<String, dynamic> json) {
    return SectionModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
} 