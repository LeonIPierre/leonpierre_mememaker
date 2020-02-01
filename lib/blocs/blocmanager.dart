import 'package:bloc/bloc.dart';
import 'package:leonpierre_mememaker/services/analytics/AnalyticsService.dart';

class BlocManager extends BlocDelegate {
  AnalyticsService analyticsService;

  BlocManager(this.analyticsService);

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    var parameters = Map<String, dynamic>();
    
    analyticsService.logAsync(transition.event.toString(), parameters);
  }
}
