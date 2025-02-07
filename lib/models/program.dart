import 'package:get/get.dart';
import 'package:i_model/core/enum/program_status.dart';

class Program {
  final String name;
  final String? image;
  final int? frequency;
  final int? pulse;
  final int? ramp;
  final int? contraction;
  final int? pause;
  final Rx<ProgramStatus>? status;

  Program({
    required this.name,
    this.image,
    this.frequency,
    this.pulse,
    this.ramp,
    this.contraction,
    this.pause,
    this.status,
  });
}
