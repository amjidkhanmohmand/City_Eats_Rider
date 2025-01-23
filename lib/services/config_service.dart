import 'package:rider/app/app.logger.dart';
import 'package:stacked/stacked_annotations.dart';

class ConfigService {
  final log = getLogger('configService');
  late String _env;
  final String _devBaseUrl = 'https://clone.cityeats.uk/api';
  final String _testBaseUrl = 'https://clone.cityeats.uk/api';
  final String _prodBaseUrl = 'https://clone.cityeats.uk/api';
  String? _baseUrl;

  /// Getters
  String get env => _env;
  String get baseUrl => _baseUrl ?? _prodBaseUrl;

  /// Constructor
  ConfigService({String? env}) {
    _env = env ?? Environment.prod;
    _setupBaseUrl();
    log.i('BASE_URL: $baseUrl');
  }

  _setupBaseUrl() {
    if (_env == Environment.prod) {
      _baseUrl = _prodBaseUrl;
    } else if (_env == Environment.test) {
      _baseUrl = _testBaseUrl;
    } else if (_env == Environment.dev) {
      _baseUrl = _devBaseUrl;
    } else {
      _baseUrl = _prodBaseUrl;
    }
  }
}
