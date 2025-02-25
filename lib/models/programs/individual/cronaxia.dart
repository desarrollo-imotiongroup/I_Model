class CronaxiaModel {
  final int id;
  final String name;
  final double value;

  CronaxiaModel({
    required this.id,
    required this.name,
    required this.value,
  });

  factory CronaxiaModel.fromJson(Map<String, dynamic> json) {
    return CronaxiaModel(
      id: json['id'],
      name: json['nombre'],
      value: json['valor']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cronaxia_id': id,
      'nombre_cronaxia': name,
      'valor_cronaxia': value,
    };
  }
}
