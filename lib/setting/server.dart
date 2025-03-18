class ServerSettings {
  Map? config;

  ServerSettings(String env) {
    if (env == 'development') {
      config = {
        'apiUrl': '52.79.200.160:4021',
        // 'apiUrl': 'localhost:4021',
      };
    } else {
      config = {'apiUrl': 'localhost:4021'};
    }
  }
}

var serverSettings = ServerSettings('development');
