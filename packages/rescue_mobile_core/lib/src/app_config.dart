/// Application-wide configuration.
class AppConfig {
  const AppConfig({
    required this.appName,
    required this.apiBaseUrl,
    this.defaultLocale = 'en_US',
  });

  final String appName;
  final String apiBaseUrl;
  final String defaultLocale;

  static const user = AppConfig(
    appName: 'Rescue User',
    apiBaseUrl: 'https://api.rescue.example/v1',
  );

  static const worker = AppConfig(
    appName: 'Rescue Worker',
    apiBaseUrl: 'https://api.rescue.example/v1',
  );
}
