import 'package:logger/logger.dart' as log;

import 'package:cuidapet_api/app/logger/i_logger.dart';

class Logger implements ILogger {
  final _logger = log.Logger();

  @override
  void debug(message, [error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  @override
  void error(message, [error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  @override
  void info(message, [error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  @override
  void warning(message, [error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);
}
