import 'dart:async';
import 'dart:html';
import 'dart:js' as JS;
import 'dart:js_util' as JSUtils;
import 'dart:html' as HTML;

class navigator {
  static Future<MediaStream> getUserMedia(
      Map<String, dynamic> mediaConstraints) async {
    try {
      final nav = HTML.window.navigator;
      if (mediaConstraints['video'] is Map) {
        if (mediaConstraints['video']['facingMode'] != null) {
          mediaConstraints['video'].remove('facingMode');
        }
      }
      final jsStream = await nav.getUserMedia(
          audio: mediaConstraints['audio'] ?? false,
          video: mediaConstraints['video'] ?? false);
      return MediaStream(jsStream);
    } catch (e) {
      throw 'Unable to getUserMedia: ${e.toString()}';
    }
  }

  static Future<MediaStream> getDisplayMedia(
      Map<String, dynamic> mediaConstraints) async {
    try {
      final mediaDevices = HTML.window.navigator.mediaDevices;
      final JS.JsObject arg = JS.JsObject.jsify(mediaConstraints);

      final HTML.MediaStream jsStream =
          await JSUtils.promiseToFuture<HTML.MediaStream>(
              JSUtils.callMethod(mediaDevices, 'getDisplayMedia', [arg]));
      return MediaStream(jsStream);
    } catch (e) {
      throw 'Unable to getDisplayMedia: ${e.toString()}';
    }
  }

  static Future<List<dynamic>> getSources() async {
    final devices = await HTML.window.navigator.mediaDevices.enumerateDevices();
    final result = [];
    for (final device in devices) {
      result.add(<String, String>{
        'deviceId': device.deviceId,
        'groupId': device.groupId,
        'kind': device.kind,
        'label': device.label
      });
    }
    return result;
  }
}
