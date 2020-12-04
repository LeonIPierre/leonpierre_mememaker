import 'package:dev_libraries/repositories/configurationrepository.dart';

class StaticAssetRepository extends ConfigurationRepository {
  @override
  Future<Map<String, dynamic>> getAll({List<String> keys}) => Future.value({
      'title' : 'Mr.Meme',
      'mrmeme:baseApiUrl': 'https://mrmeme.io/api',
      'appSpector:androidApiKey': 'android_ZDRkYjk5ZjYtOGJjYy00ZGM1LWFmY2UtYTAwOWY1NzMzZTA2',
      'appSpector:iosApiKey': 'ios_NWYwZjQyOTQtNWYxMi00ZjQyLTk2ODctODMzNzY4Y2M5YzM1',
      'googleAdMob:appId': 'ca-app-pub-9962567440326517~4869787060',
      'googleAdMob:bannerAdUnitId' : 'ca-app-pub-3940256099942544/6300978111',
      'googleAdMob:intersitialAdUnitId': 'ca-app-pub-3940256099942544/1033173712',
      'googleAdMob:intersitialVideoAdUnitId': 'ca-app-pub-3940256099942544/8691691433',
      'googleAdMob:nativeAdUnitId': 'ca-app-pub-3940256099942544/2247696110',
      'googleAdMob:nativeVideoAdUnitId': 'ca-app-pub-3940256099942544/2247696110',
      'googleAdMob:rewardAdUnitId': 'ca-app-pub-3940256099942544/1044960115'
    });
  
    @override
    Future<bool> save<T>(String key, T value) {
    // TODO: implement save
    throw UnimplementedError();
  }

}