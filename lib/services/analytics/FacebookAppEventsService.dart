//import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:leonpierre_mememaker/services/analytics/AnalyticsService.dart';

class FacebookAppEventService extends AnalyticsService{
  //final facebookAppEvents = FacebookAppEvents();

  @override
  void logAsync(String event, Map<String, dynamic> parameters) async {
    //pick out a valueToSum item
    //await facebookAppEvents.logEvent(name: event, parameters: parameters);
  }

  @override
  activateAsync() async => {};
}
