import 'package:i_model/models/programs/individual/cronaxia.dart';
import 'package:i_model/models/programs/individual/muscle_group.dart';

class IndividualProgramModel {
  final int id;
  final String name;
  final String image;
  final double frequency;
  final double pulse;
  final double ramp;
  final double contraction;
  final double pause;
  final String type;
  final String equipmentType;
  final List<CronaxiaModel> cronaxias;
  final List<MuscleGroupModel> muscleGroups;

  IndividualProgramModel({
    required this.id,
    required this.name,
    required this.image,
    required this.frequency,
    required this.pulse,
    required this.ramp,
    required this.contraction,
    required this.pause,
    required this.type,
    required this.equipmentType,
    required this.cronaxias,
    required this.muscleGroups,
  });

  factory IndividualProgramModel.fromJson(Map<String, dynamic> json) {
    return IndividualProgramModel(
      id: json['id_programa'],
      name: json['nombre'],
      image: json['imagen'],
      frequency: json['frecuencia'].toDouble(),
      pulse: json['pulso'].toDouble(),
      ramp: json['rampa'].toDouble(),
      contraction: json['contraccion'].toDouble(),
      pause: json['pausa'].toDouble(),
      type: json['tipo'],
      equipmentType: json['tipo_equipamiento'],
      cronaxias: List<CronaxiaModel>.from(
        json['cronaxias']?.map((x) => CronaxiaModel.fromJson(x)) ?? [],
      ),
      muscleGroups: List<MuscleGroupModel>.from(
        json['grupos_musculares']?.map((x) => MuscleGroupModel.fromJson(x)) ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_programa': id,
      'nombre': name,
      'imagen': image,
      'frecuencia': frequency,
      'pulso': pulse,
      'rampa': ramp,
      'contraccion': contraction,
      'pausa': pause,
      'tipo': type,
      'tipo_equipamiento': equipmentType,
      'cronaxias': cronaxias.map((x) => x.toJson()).toList(),
      'grupos_musculares': muscleGroups.map((x) => x.toJson()).toList(),
    };
  }
}


