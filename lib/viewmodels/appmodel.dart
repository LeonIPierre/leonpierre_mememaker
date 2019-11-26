class AppModel {
    Map<String, String>  config;

    AppModel(Map<String, String> config)
    {
      this.config = config;

      config['title'] = 'Hello world';
      config['home:title'] = 'Hello world from Home';
    }
}