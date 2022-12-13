extension FileExtension on String {
  String get file {
    return split('/').last;
  }

  String get fileName {
    return file.split('.').first;
  }

  DateTime get dateTime {
    var epochTime = fileName.split('Doc_').last;
    return DateTime.fromMillisecondsSinceEpoch(int.parse(epochTime));
  }
}
