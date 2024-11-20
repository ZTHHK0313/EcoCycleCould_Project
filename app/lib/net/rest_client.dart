import 'dart:io';

import 'package:async/async.dart';
import 'package:http/http.dart'
    hide delete, get, head, patch, post, put, read, readBytes, runWithClient;
import 'package:package_info_plus/package_info_plus.dart';

String get _runningPlatform {
  if (Platform.isIOS) {
    return "iOS";
  } else if (Platform.isAndroid) {
    return "Android";
  }

  return "";
}

base class RestClient extends BaseClient {
  late final Client _client;

  static final AsyncMemoizer<String> _uaStrMemorizer = AsyncMemoizer();

  static Future<String> get userAgentString =>
      _uaStrMemorizer.runOnce(() async {
        PackageInfo pkgInfo = await PackageInfo.fromPlatform();

        StringBuffer uaBuf = StringBuffer();

        uaBuf
          ..write("ECCLoyalty/")
          ..write(pkgInfo.version)
          ..write(" (")
          ..write(_runningPlatform)
          ..write(")");

        return uaBuf.toString();
      });

  RestClient([Client? client]) {
    _client = client ?? Client();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    request.headers["user-agent"] = await userAgentString;

    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}
