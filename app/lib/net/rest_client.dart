import 'dart:io';

import 'package:cronet_http/cronet_http.dart';
import 'package:cupertino_http/cupertino_http.dart';
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

final class RestClient extends BaseClient {
  late final Client _client;
  final Uri apiGateway;

  RestClient(this.apiGateway, [Client? client]) {
    Client defaultClient;

    if (Platform.isIOS) {
      final sessionConf =
          URLSessionConfiguration.ephemeralSessionConfiguration()
            ..httpCookieAcceptPolicy =
                NSHTTPCookieAcceptPolicy.NSHTTPCookieAcceptPolicyNever
            ..cache = null;

      defaultClient = CupertinoClient.fromSessionConfiguration(sessionConf);
    } else if (Platform.isAndroid) {
      final engine =
          CronetEngine.build(cacheMode: CacheMode.disabled, enableHttp2: true);

      defaultClient = CronetClient.fromCronetEngine(engine, closeEngine: true);
    } else {
      defaultClient = Client();
    }

    _client = client ?? defaultClient;
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {    
    PackageInfo pkgInfo = await PackageInfo.fromPlatform();

    StringBuffer uaBuf = StringBuffer();

    uaBuf
      ..write("ECCLoyalty/")
      ..write(pkgInfo.version)
      ..write(" (")
      ..write(_runningPlatform)
      ..write(")");

    request.headers["user-agent"] = uaBuf.toString();

    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}
