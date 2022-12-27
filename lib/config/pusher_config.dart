import 'package:business_01/config/server_config.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:pusher_client/pusher_client.dart';

class PusherConfig{
  static const appIp = '1492385';
  static const kay = '384ffaa7750f8938416a';
  static const secret = 'd17d063c6f5f229e960f';
  static const cluster = 'ap2';
  static const hostEndPint = ServerConfig.ServerDomain;
  static const hostAuthEndPint = '${hostEndPint}/broadcasting/auth';
  static const port = 6001;
}


class LaravelEcho {
  static LaravelEcho? _singleton;
  static late Echo _echo;
  final String Token;

  LaravelEcho._({
    required this.Token
}) {
    _echo = CreateLaravelEcho(Token);
  }

  factory LaravelEcho.init({
    required String Token,
}){
    if(_singleton == null || Token != _singleton?.Token) {
      _singleton = LaravelEcho._(Token: Token);
    }
    return _singleton!;
  }

  static Echo get instance => _echo;

  static String get SocketId => _echo.socketId() ?? "11111.11111111";
}

PusherClient CreatePusherClient(String Token){
  PusherOptions options = PusherOptions(
    wsPort:  PusherConfig.port,
    encrypted: true,
    host: PusherConfig.hostEndPint,
    cluster:  PusherConfig.cluster,

    // auth:  PusherAuth(
    //   PusherConfig.hostAuthEndPint,
    //   headers: {
    //     'Authorization' : 'Bearer $Token',
    //     'Content-Type' : 'application/json',
    //     'Accept' : 'application/json'
    //   }
    // )
  );

  PusherClient pusherClient = PusherClient(
    PusherConfig.kay,
    options,
    autoConnect: true,
    enableLogging: true
  );

  return pusherClient;
}

Echo CreateLaravelEcho(String Token){
  return Echo(
    client: CreatePusherClient(Token),
    broadcaster: EchoBroadcasterType.Pusher,
  );
}