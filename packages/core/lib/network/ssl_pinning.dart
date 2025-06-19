import 'dart:io';

import 'package:flutter/services.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;

class SSLPinning {
  static Future<http.Client> get _instance async =>
      _clientInstance ??= await ioClient();

  static http.Client? _clientInstance;
  static http.Client get client => _clientInstance ?? http.Client();

  static Future<void> init() async {
    _clientInstance = await _instance;
  }

  static Future<SecurityContext> get globalContext async {
    final sslCert = await rootBundle.load('ssl_cert/_.themoviedb.org.crt');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    return securityContext;
  }

  static Future<IOClient> ioClient() async {
    HttpClient client = HttpClient(context: await globalContext);
    client.badCertificateCallback =
        (X509Certificate cert, String host, int port) => false;
    final ioClient = IOClient(client);
    return ioClient;
  }
}
