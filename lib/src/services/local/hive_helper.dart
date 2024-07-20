import 'package:hive_flutter/hive_flutter.dart';
import 'package:diversid/src/constants/constants.dart';

Future<void> hiveInit() async {
  await Hive.initFlutter('cache');

  /// [TODO]
  /// Open Hive Box
  await Hive.openBox(HiveBoxKey.commonBox);
}

Future<void> hiveClose() async {
  await Hive.close();
}
