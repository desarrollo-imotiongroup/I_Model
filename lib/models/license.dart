import 'package:get/get.dart';

class License {
  final String mci;
  final String type;
  RxString status;

  License({
    required this.mci,
    required this.type,
    required this.status,
  });
}
