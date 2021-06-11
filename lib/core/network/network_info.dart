import 'package:data_connection_checker/data_connection_checker.dart';

/// Checks for the deivce's internet connectivity
///
/// return [isConnected] to [true] if connected
/// to internet
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;
  NetworkInfoImpl(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
