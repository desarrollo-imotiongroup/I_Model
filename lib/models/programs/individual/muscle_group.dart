class MuscleGroupModel {
  final int id;
  final String name;

  MuscleGroupModel({
    required this.id,
    required this.name,
  });

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) {
    return MuscleGroupModel(
      id: json['grupo_muscular_id'],
      name: json['nombre_grupo_muscular'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'grupo_muscular_id': id,
      'nombre_grupo_muscular': name,
    };
  }
}
