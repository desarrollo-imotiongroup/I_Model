import 'package:i_model/models/programs/automatic/sub_program.dart';

class AutomaticProgramModel {
  final int automaticProgramId;
  final String name;
  final String image;
  final String description;
  final double totalDuration;
  final String equipmentType;
  final List<Subprogram> subprograms;

  AutomaticProgramModel({
    required this.automaticProgramId,
    required this.name,
    required this.image,
    required this.description,
    required this.totalDuration,
    required this.equipmentType,
    required this.subprograms,
  });

  factory AutomaticProgramModel.fromJson(Map<String, dynamic> json) {
    var list = json['subprogramas'] as List;
    List<Subprogram> subprogramsList = list.map((i) => Subprogram.fromJson(i)).toList();

    return AutomaticProgramModel(
      automaticProgramId: json['id_programa_automatico'],
      name: json['nombre'],
      image: json['imagen'],
      description: json['descripcion'],
      totalDuration: json['duracionTotal'].toDouble(),
      equipmentType: json['tipo_equipamiento'],
      subprograms: subprogramsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_programa_automatico': automaticProgramId,
      'nombre': name,
      'imagen': image,
      'descripcion': description,
      'duracionTotal': totalDuration,
      'tipo_equipamiento': equipmentType,
      'subprogramas': subprograms.map((e) => e.toJson()).toList(),
    };
  }
}
