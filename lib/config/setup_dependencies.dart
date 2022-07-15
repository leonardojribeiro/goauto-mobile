import 'package:get_it/get_it.dart';
import 'package:goauto/modules/clients/repositories/clients_repository.dart';
import 'package:goauto/modules/orders/repositories/orders_repository.dart';
import 'package:goauto/modules/providers/repositories/providers_repository.dart';
import 'package:goauto/modules/vehicles/repositories/vehicles_repository.dart';

void setupDependencies() {
  GetIt.I.registerLazySingleton(() => ClientsRepository());
  GetIt.I.registerLazySingleton(() => VehiclesRepository());
  GetIt.I.registerLazySingleton(() => ProvidersRepository());
  GetIt.I.registerLazySingleton(() => OrdersRepository());
}
