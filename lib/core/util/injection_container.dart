import 'package:get_it/get_it.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/simi_products/presentation/manger/semi_finished_products_cubit.dart';
import 'package:tcp212/feutaure/simi_products/repo/semi_finished_products_repository_impl.dart';

final sl = GetIt.instance;

void init() {
  // Cubit
  sl.registerFactory(() => SemiFinishedProductsCubit(sl()));

  // Repository
  sl.registerLazySingleton<SemiFinishedProductsRepositoryImpl>(
    () => SemiFinishedProductsRepositoryImpl(sl()),
  );

  // External
  sl.registerLazySingleton(() => ApiService());
}
