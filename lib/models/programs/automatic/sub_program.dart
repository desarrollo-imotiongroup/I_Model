class Subprogram {
  final int automaticProgramId;
  final int relatedProgramId;
  final String name;
  final int order;
  final double adjustment;
  final double duration;
  final String image;
  final double frequency;
  final double pulse;
  final double ramp;
  final double contraction;
  final double pause;

  Subprogram({
    required this.automaticProgramId,
    required this.relatedProgramId,
    required this.name,
    required this.order,
    required this.adjustment,
    required this.duration,
    required this.image,
    required this.frequency,
    required this.pulse,
    required this.ramp,
    required this.contraction,
    required this.pause,
  });

  // Utility function to safely parse pulse to double
  static double parsePulse(dynamic value) {
    if (value is String) {
      var parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed;
      } else {
        return 0.0;
      }
    }
    // If it's already a number (int or double), return it as is
    return value?.toDouble() ?? 0.0;
  }

  factory Subprogram.fromJson(Map<String, dynamic> json) {
    return Subprogram(
      automaticProgramId: json['id_programa_automatico'],
      relatedProgramId: json['id_programa_relacionado'],
      name: json['nombre'],
      order: json['orden'],
      adjustment: json['ajuste'].toDouble(),
      duration: json['duracion'].toDouble(),
      image: json['imagen'],
      frequency: json['frecuencia'].toDouble(),
      pulse: parsePulse(json['pulso']),  // Handle 'pulso' with safe parsing
      ramp: json['rampa'].toDouble(),
      contraction: json['contraccion'].toDouble(),
      pause: json['pausa'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_programa_automatico': automaticProgramId,
      'id_programa_relacionado': relatedProgramId,
      'nombre': name,
      'orden': order,
      'ajuste': adjustment,
      'duracion': duration,
      'imagen': image,
      'frecuencia': frequency,
      'pulso': pulse,
      'rampa': ramp,
      'contraccion': contraction,
      'pausa': pause,
    };
  }
}
