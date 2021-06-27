import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstInstall()async {

  SharedPreferences firstInstallPref = await SharedPreferences.getInstance();
  if(firstInstallPref.getString("installedConfirm") == null) return true;
  else return false;

}