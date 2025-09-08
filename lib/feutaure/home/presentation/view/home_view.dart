import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/assets_image.dart';
import 'package:tcp212/feutaure/counts/presentation/manger/products_count_cubit.dart';
import 'package:tcp212/feutaure/counts/presentation/manger/row_counts_state.dart';
import 'package:tcp212/feutaure/counts/presentation/manger/row_matirals_count_cubit.dart';
import 'package:tcp212/feutaure/counts/repo/products_count_repository_impl.dart';
import 'package:tcp212/feutaure/home/presentation/view/navigator_product.dart';
import 'package:tcp212/feutaure/home/presentation/view/navigator_raw_material.dart';
import 'package:tcp212/feutaure/home/presentation/view/widget/build_properties_container.dart';
import 'package:tcp212/feutaure/home/presentation/view/widget/card_row_materials.dart';
import 'package:tcp212/feutaure/home/presentation/view/widget/slider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> sliderImages = [
      Assets.assetsImagesGoogleSymbol,
      Assets.assetsImagesLogoTPC,
      Assets.assetsImagesLogoTPC,
      Assets.assetsJsonOnboarding3,
      Assets.assetsImagesLogo2,
    ];

    return MultiBlocProvider(
      providers: [
        BlocProvider<ProductsCountCubit>(
          create: (context) => ProductsCountCubit(
            repository: ProductsCountRepositoryImpl(
              apiService: ApiService(), // إنشاء ApiService مباشرة
            ),
          )..fetchProductsCount(),
        ),
        BlocProvider<RawMaterialsCountCubit>(
          create: (context) => RawMaterialsCountCubit(
            repository: ProductsCountRepositoryImpl(
              apiService: ApiService(), // إنشاء ApiService مباشرة
            ),
          )..fetchRawMaterialsCount(),
        ),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomImageSlider(imageList: sliderImages),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          BlocBuilder<ProductsCountCubit, ProductsCountState>(
                            builder: (context, state) {
                              if (state is ProductsCountLoaded) {
                                return BirthdayCard(
                                  ontap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NavigatorRawMaterial(),
                                      ),
                                    );
                                  },
                                  tite: 'Raw Materials',
                                  iconData: Icons.check_circle,
                                  listColor: [
                                    Color(0xFF1976D2),
                                    Color(0xFF64B5F6),
                                  ],
                                  count: state.count,
                                );
                              } // عرض مؤشر تحميل

                              return SizedBox(height: 8, width: 8);
                            },
                          ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child:
                          BlocBuilder<
                            RawMaterialsCountCubit,
                            RawMaterialsCountState
                          >(
                            builder: (context, state) {
                              if (state is RawMaterialsCountLoaded) {
                                return BirthdayCard(
                                  ontap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            NavigatorProduct(),
                                      ),
                                    );
                                  },
                                  tite: 'Products',
                                  iconData: Icons.cancel,
                                  listColor: [
                                    Color.fromARGB(255, 244, 139, 54),
                                    Color(0xFFE57373),
                                  ],
                                  count: '${state.count}',
                                );
                              }
                              return const SizedBox(height: 8, width: 8);
                            },
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              buildPropertiesContainer(context),
            ],
          ),
        ),
      ),
    );
  }
}
