
const int port = 6001;
const String cluster = "mt1";

/*
const String appDomain = "192.168.1.112";
const String appUrl = "http://192.168.1.112:8000";
const bool forceTLS = false;
const bool encrypted = false;
const String appKey = "POwQcpXGJ9";
*/

/*
const String appDomain = "eglisesetserviteursdedieu.com";
const String appUrl = "https://eglisesetserviteursdedieu.com";
const bool forceTLS = true;
const bool encrypted = true;
const String appKey = "POwQcpXGJ9";

Echo echoSetup(token, pusherClient) {
  return Echo({
    'broadcaster': 'pusher',
    'client': pusherClient,
    "wsHost": appDomain,
    "httpHost": appDomain,
    "wsPort": port,
    'wssPort': port,
    'auth': {
      "headers": {
        'Authorization': 'Bearer $token',
      }
    },
    'authEndpoint': appUrl + '/api/broadcasting/auth',
    "disableStats": true,
    // "forceTLS": forceTLS,
    "enabledTransports": ['ws', 'wss']
  });
}

FlutterPusher getPusherClient(String token) {
  PusherOptions options = PusherOptions(
    encrypted: encrypted,
    host: appDomain,
    cluster: cluster,
    port: 6001,
    auth: PusherAuth(
      appUrl + '/api/broadcasting/auth',
      headers: {
        'Authorization': 'Bearer $token',
      },
    ),
  );

  return FlutterPusher(appKey, options, enableLogging: true);
}

Future<Echo> getEcho(
    {required void Function(ConnectionStateChange)
        onConnectionStateChange}) async {
  final token = await FlutterSecureStorage().read(key: 'auth_token');

  FlutterPusher pusherClient = getPusherClient(token!);

  Echo echo = echoSetup(token, pusherClient);

  pusherClient.connect(onConnectionStateChange: onConnectionStateChange);

  return echo;
}
*/