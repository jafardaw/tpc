import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/app_router.dart';
import 'package:tcp212/core/util/injection_container.dart' as di;
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_add/add_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_get/get_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/presentation/view/manager/cubit_update/updat_batch_raw_cubit.dart';
import 'package:tcp212/feutaure/Batch_Raw_Material/repo/repo_batch_raw_material.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/manger/cubit/cubit/product_summary_report_cubit.dart';
import 'package:tcp212/feutaure/ProductSaleReports/repo/product_summary_repository_imp.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/cubit_update/update_product_cubit.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/get_cubit/get_all_product_cubit.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/update_price_cubit/cubit/updateproductprice_cubit.dart';
import 'package:tcp212/feutaure/Product/repo/repo_product.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_search/search_raw_material_cubit_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_update/raw_update_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/repo/raw_material_repo.dart';
import 'package:tcp212/feutaure/simi_products/presentation/manger/semi_finished_products_cubit.dart';

import 'package:tcp212/feutaure/damagedmaterial/presentation/manger/cubit/cubit/create_damaged_material_cubit.dart';
import 'package:tcp212/feutaure/damagedmaterial/repo/damaged_material_repository_imp.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/all_product_batch_view.dart';
import 'package:tcp212/feutaure/productBatch/presentation/view/manager/getallProductbatch_Cubit/all_lproduct_batch_cubit.dart';
import 'package:tcp212/feutaure/productBatch/repo/repo_product_batch.dart';
import 'package:tcp212/feutaure/productmaterial/presentation/view/all_product_material_view.dart';
import 'package:tcp212/feutaure/productmaterial/repo/repo_product_material.dart';
import 'package:tcp212/feutaure/simi_products/repo/semi_finished_products_repository_impl.dart';
import 'package:tcp212/view_models/auth_cubit/auth_cubit.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await setupNotifications();

  //   // الاستماع لحدث الضغط على الإشعار وفتح التطبيق
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     // ببساطة، انتقل إلى صفحة الإشعارات
  //     navigatorKey.currentState?.pushNamed('/notifications_page');

  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();

  runApp(MyApp(sharedPreferences: sharedPreferences));
  // }
}

class MyApp extends StatelessWidget {
  final SharedPreferences sharedPreferences;

  const MyApp({super.key, required this.sharedPreferences});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RawMaterialBatchesListCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProductSummaryReportCubit(
            ProductSummaryRepositoryImp(ApiService()),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateBatchRawMaterialCubit(
            RawMaterialBatchRepository(
              ApiService(),
            ), // Provide ApiService to the repo
          ),
        ),
        BlocProvider(
          create: (context) => AddRawMaterialBatchCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService، يمكنك استخدام Injection هنا إذا كان لديك
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateRawMaterialCubit(
            rawMaterialRepository: RawMaterialRepository(
              apiService: ApiService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => RawMaterialSearchCubit(
            repository: RawMaterialRepository(apiService: ApiService()),
          ),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(sharedPreferences),
        ),
        BlocProvider(create: (context) => di.sl<SemiFinishedProductsCubit>()),
        BlocProvider(
          create: (context) => RawMaterialBatchesListCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProductSummaryReportCubit(
            ProductSummaryRepositoryImp(ApiService()),
          ),
        ),
        BlocProvider(
          create: (context) => CreateDamagedMaterialCubit(
            DamagedMaterialRepositoryImp(ApiService()),
          ),
        ),
        BlocProvider(
          create: (context) =>
              UpdateproductpriceCubit(ProductListRepo(ApiService())),
          child: ProductBatchListView(),
        ),
        BlocProvider(
          create: (context) =>
              ProductBatchCubit(ProductBatchRepo(apiService: ApiService())),
          child: ProductBatchListView(),
        ),
        BlocProvider<SemiFinishedProductsCubit>(
          create: (context) => SemiFinishedProductsCubit(
            SemiFinishedProductsRepositoryImpl(ApiService()),
          )..getSemiFinishedProducts(),
        ),
        BlocProvider<GetRawMaterialsCubit>(
          create: (context) => GetRawMaterialsCubit(
            rawMaterialRepository: RawMaterialRepository(
              apiService: ApiService(),
            ),
          )..fetchRawMaterials(),
        ),
        BlocProvider(
          create: (context) => ProductMaterialsCubit(
            ProductMaterialsRepo(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateProductCubit(
            productRepository: ProductListRepo(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => ProductListCubit(
            ProductListRepo(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => RawMaterialBatchesListCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateBatchRawMaterialCubit(
            RawMaterialBatchRepository(
              ApiService(),
            ), // Provide ApiService to the repo
          ),
        ),
        BlocProvider(
          create: (context) => AddRawMaterialBatchCubit(
            RawMaterialBatchRepository(
              ApiService(), // إنشاء ApiService، يمكنك استخدام Injection هنا إذا كان لديك
            ),
          ),
        ),
        BlocProvider(
          create: (context) => UpdateRawMaterialCubit(
            rawMaterialRepository: RawMaterialRepository(
              apiService: ApiService(),
            ),
          ),
        ),
        BlocProvider(
          create: (context) => RawMaterialSearchCubit(
            repository: RawMaterialRepository(apiService: ApiService()),
          ),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(sharedPreferences),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Inter'),
            routerConfig: router,
          );
        },
      ),
    );
  }
}
