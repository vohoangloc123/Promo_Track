class Discount {
  final int id;
  final double percentage;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isAppliedDirectly;

  Discount({
    required this.id,
    required this.percentage,
    required this.validFrom,
    required this.validUntil,
    required this.isAppliedDirectly,
  });

  factory Discount.fromMap(Map<String, dynamic> map) {
    return Discount(
      id: map['id'],
      percentage: map['percentage'].toDouble(),
      validFrom: DateTime.parse(map['valid_from']),
      validUntil: DateTime.parse(map['valid_until']),
      isAppliedDirectly: map['is_applied_directly'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'percentage': percentage,
      'valid_from': validFrom.toIso8601String(),
      'valid_until': validUntil.toIso8601String(),
      'is_applied_directly': isAppliedDirectly ? 1 : 0,
    };
  }
}
