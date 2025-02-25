class MuscleGroupModel {
  final int id;
  final String name;

  MuscleGroupModel({
    required this.id,
    required this.name,
  });

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) {
    return MuscleGroupModel(
      id: json['id'],
      name: json['nombre'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grupo_muscular_id': id,
      'nombre_grupo_muscular': name,
    };
  }
}
