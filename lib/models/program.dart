class Program {
  final String name;
  final String? image;
  final int? frequency;
  final int? pulse;
  final int? ramp;
  final int? contraction;
  final int? pause;

  Program({
    required this.name,
    this.image,
    this.frequency,
    this.pulse,
    this.ramp,
    this.contraction,
    this.pause,
  });
}
