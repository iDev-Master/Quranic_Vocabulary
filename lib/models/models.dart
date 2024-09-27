class Word {
  final int level;
  final String word;
  final String ru;
  final String tj;
  final String uz;
  final String ir;
  final String type;
  final int occurrence;
  final double percentage;
  final String exampleAr;
  final String exampleRu;
  final String exampleTj;
  final String exampleUz;
  final String exampleIr;
  final String combinations;
  final int counter;

  Word({
    required this.level,
    required this.word,
    required this.ru,
    required this.tj,
    required this.uz,
    required this.ir,
    required this.type,
    required this.occurrence,
    required this.percentage,
    required this.exampleAr,
    required this.exampleRu,
    required this.exampleTj,
    required this.exampleUz,
    required this.exampleIr,
    required this.combinations,
    required this.counter,
  });

  // Convert a map to a Word object
  factory Word.fromMap(Map<String, dynamic> map) {
    return Word(
      level: map['level'],
      word: map['word'],
      ru: map['ru'],
      tj: map['tj'],
      uz: map['uz'],
      ir: map['ir'],
      type: map['type'],
      occurrence: map['occurrence'],
      percentage: map['percentage'],
      exampleAr: map['exampleAr'],
      exampleRu: map['exampleRu'],
      exampleTj: map['exampleTj'],
      exampleUz: map['exampleUz'],
      exampleIr: map['exampleIr'],
      combinations: map['combinations'],
      counter: map['counter'],
    );
  }

  // Convert a Word object to a map
  Map<String, dynamic> toMap() {
    return {
      'level': level,
      'word': word,
      'ru': ru,
      'tj': tj,
      'uz': uz,
      'ir': ir,
      'type': type,
      'occurrence': occurrence,
      'percentage': percentage,
      'exampleAr': exampleAr,
      'exampleRu': exampleRu,
      'exampleTj': exampleTj,
      'exampleUz': exampleUz,
      'exampleIr': exampleIr,
      'combinations': combinations,
      'counter': counter,
    };
  }
}
