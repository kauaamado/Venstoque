import '../models/sync_report.dart';

abstract interface class SyncGateway {
  Future<SyncReport> syncAll();

  Future<SyncReport> syncCustomersFromServer();

  Future<SyncReport> syncProductsFromServer();

  Future<SyncReport> syncSalesFromServer();
}
