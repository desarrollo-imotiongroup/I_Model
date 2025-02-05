import 'package:i_model/core/strings.dart';
import 'package:i_model/models/program.dart';

class Consts{
 static List<Program> individualProgramsList = [
    Program(name: Strings.celluliteIndProgram, image: Strings.celluliteIcon),
    Program(name: Strings.buttocksIndProgram, image: Strings.buttocksIndividualIcon),
    Program(name: Strings.contractures, image: Strings.contracturesIcon),
    Program(name: Strings.drainage, image: Strings.drainageIcon),
    Program(name: Strings.hypertrophyIndProgram, image: Strings.hypertrophyIcon),
    Program(name: Strings.pelvicFloorIndProgram, image: Strings.pelvicFloorIcon),
    Program(name: Strings.slimIndProgram, image: Strings.slimIcon),
    Program(name: Strings.toningIndProgram, image: Strings.toningIcon),
    Program(name: Strings.massage, image: Strings.massageIcon),
    Program(name: Strings.metabolic, image: Strings.metabolicIcon),
    Program(name: Strings.calibration, image: Strings.calibrationIcon),
    Program(name: Strings.strength, image: Strings.strengthIcon),
 ];

 static List<Program> automaticProgramsList = [
    Program(name: Strings.buttocks, image: Strings.buttocksAutoIcon),
    Program(name: Strings.cellulite, image: Strings.celluliteAutoIcon),
    Program(name: Strings.hypertrophy, image: Strings.hypertrophyAutoIcon),
    Program(name: Strings.pelvicFloor, image: Strings.pelvicFloorAutoIcon),
    Program(name: Strings.slim, image: Strings.slimAutoIcon),
    Program(name: Strings.toning, image: Strings.toningAutoIcon),
  ];



}