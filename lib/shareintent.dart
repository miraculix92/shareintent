import 'dart:async';
import 'package:shareintentinterface/ShareIntentInterface.dart';

class ShareIntent {

  factory ShareIntent() {
    if (_singleton == null) {
      _singleton = ShareIntent._();
    }
    return _singleton;
  }

  ShareIntent._();

  static ShareIntent _singleton;

  static ShareIntentPlatform get _platform => ShareIntentPlatform.instance;

  Stream<String> get onShareIntent {
    return _platform.onShareIntentReceived;
  }

  Future<String> getSharedContent() {
    return _platform.getSharedContent();
  }
}
