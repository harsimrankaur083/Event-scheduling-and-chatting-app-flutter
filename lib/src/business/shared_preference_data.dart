import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceData {
  static Future<void> setUserUID(String userUID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userUID', userUID);
  }

  static Future<String> getUserUID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = await prefs.getString('userUID') ?? null;
    return stringValue;
  }

  static Future<void> setDeviceID(String deviceID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('deviceID', deviceID);
  }

  static Future<String> getDeviceID() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String stringValue = await prefs.getString('deviceID') ?? null;
    return stringValue;
  }

  void removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("userUID");
  }

  static addBoolFirstScreenSee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('boolValue', true);
  }

  static Future<bool> getBoolFirstScreenSee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool('boolValue');

    if (boolValue == null) {
      return false;
    }
    return boolValue;
  }
}
