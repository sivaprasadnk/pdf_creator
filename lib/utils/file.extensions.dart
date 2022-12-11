extension FileExtension on String {
  String get file {
    return split('/').last;
  }

  DateTime get dateTime {
    var fileName = file.split('.').first;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(fileName));
  }
}
