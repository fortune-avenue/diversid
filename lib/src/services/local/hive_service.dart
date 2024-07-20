import 'package:diversid/src/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  /// [TODO]
  /// all business logic in hive
  final commonBox = Hive.box(HiveBoxKey.commonBox);

  set isFirstInstall(bool isFirstInstall) {
    commonBox.put(HiveKey.isFirstInstall, isFirstInstall);
  }

  bool get isFirstInstall {
    final isFirstInstall =
        commonBox.get(HiveKey.isFirstInstall, defaultValue: true) as bool;
    return isFirstInstall;
  }
}

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});
