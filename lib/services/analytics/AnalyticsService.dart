abstract class AnalyticsService {
  activateAsync();
  logAsync(String event, Map<String, dynamic> parameters);
}