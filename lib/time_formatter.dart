
class TimeFormatter{

  /// 時間:分:秒 形式の文字列に変換します.
  /// ms以下は1秒切り上げます.
  static String formatToHMSColon(Duration duration){
    int seconds = (duration.inMilliseconds / Duration.millisecondsPerSecond).ceil();
    Duration roundingDuration = Duration(seconds: seconds);
    return roundingDuration.toString().replaceAll(RegExp("\\..*"), "");
  }
}