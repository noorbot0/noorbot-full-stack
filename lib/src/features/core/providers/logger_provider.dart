// import 'package:cloud_functions/cloud_functions.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoggerProvider {
  final SharedPreferences prefs;

  final log = Logger(
    printer: PrettyPrinter(
        methodCount: 2, // number of method calls to be displayed
        errorMethodCount: 8, // number of method calls if stacktrace is provided
        lineLength: 120, // width of the output
        colors: true, // Colorful log messages
        printEmojis: true, // Print an emoji for each log message
        printTime: true // Should each log print contain a timestamp
        ),
  );

  LoggerProvider({
    required this.prefs,
  });

  String? getPref(String key) {
    return prefs.getString(key);
  }

  void error(String error) {
    log.e(error);
  }

  void shit(String theShit) {
    log.wtf(theShit);
  }

  void info(String msg) {
    log.i(msg);
  }

  void warn(String warn) {
    log.w(warn);
  }

  void debug(String val) {
    log.d(val);
  }

  void verbose(String what) {
    log.v(what);
  }
}
