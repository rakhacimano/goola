const String tableGlucose = 'glucose';

class GlucoseFields {
  static const String id = 'id';
  static const String time = 'time';
  static const String amount = 'amount';
}

class Glucose {
  final int? id;
  final DateTime createdTime;
  final String amount;

  Glucose({
    this.id,
    required this.createdTime,
    required this.amount,
  });

  Glucose copy({
    int? id,
    DateTime? createdTime,
    String? amount
  }) {
    return Glucose(
      createdTime: createdTime ?? this.createdTime,
      amount: amount ?? this.amount
    );
  }

  static Glucose fromJson(Map<String, Object?> json) {
    return Glucose(
      id: json[GlucoseFields.id] as int?,
      amount: json[GlucoseFields.amount] as String,
      createdTime: DateTime.parse(json[GlucoseFields.time] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      GlucoseFields.id: id,
      GlucoseFields.time: createdTime.toIso8601String(),
      GlucoseFields.amount: amount
    };
  }
}