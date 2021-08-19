import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
// not  used
class DeviceUniqueId {
 static Future<String> getDeviceUniqueID() async {
    String identifier;
    final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var build = await deviceInfoPlugin.androidInfo;
        identifier = build.id.toString();
      } else if (Platform.isIOS) {
        var data = await deviceInfoPlugin.iosInfo;
        identifier = data.identifierForVendor; //UUID for iOS
      }
    } on PlatformException {
      print('Failed to get platform version');
    }
    print('fcm>>'+identifier);
    return identifier;
  }
}
