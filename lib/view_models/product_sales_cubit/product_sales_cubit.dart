import 'dart:convert';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tcp212/models/product_sales_model.dart';
import 'package:tcp212/view_models/product_sales_cubit/product_sales_state.dart';

class ProductSalesCubit extends Cubit<ProductSalesState> {
  ProductSalesCubit() : super(ProductSalesLoading());
  final String baseUrl = 'http://127.0.0.1:8000/api';
  Future<void> fetchProductSales() async {
    emit(ProductSalesLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final response = await http.get(Uri.parse('$baseUrl/product-sales'),
          headers: {"Authorization": "Bearer $token"});
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body)['data'];
        try {
          final productSales = data.map((e) {
            try {
              log('محاولة تحليل المنتج: ${e['product_sale_id']}');
              return ProductSale.fromJson(e as Map<String, dynamic>);
            } catch (parseError) {
              log('خطأ في تحليل المنتج: $parseError');
              log('بيانات المنتج: $e');
              rethrow;
            }
          }).toList();
          emit(ProductSalesLoaded(productSales));
        } catch (e) {
          emit(ProductSalesError('خطأ في تحليل البيانات: $e'));
          log('خطأ في تحليل البيانات: $e');
        }
      } else {
        emit(ProductSalesError('فشل التحميل'));
      }
    } catch (e) {
      emit(ProductSalesError('خطأ في الاتصال: $e'));
      log('خطأ في الاتصال: $e');
    }
  }

  Future<void> fetchSalesByID(int id) async {
    emit(ProductSalesLoading());
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/product-sales/$id'),
        headers: {
          "Authorization":
              "Bearer 2|POJ0t11nnwFYVsKHrbgcQwdZJ8mwg96M4uuAeWyd4cfcb472",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );
      log("1");
      if (response.statusCode == 200 || response.statusCode == 200) {
        log("2");
        final jsonBody = json.decode(response.body);
        final productSales = ProductSale.fromJson(jsonBody['data']);
        log("3");
        log(productSales.toString());
        emit(ProductSalesLoaded([productSales]));
      } else {
        emit(ProductSalesError('Failed to load expense'));
      }
    } catch (e) {
      emit(ProductSalesError(e.toString()));
    }
  }

  Future<void> deleteSale(int id) async {
    var headers = {
      'Accept': 'application/json',
      'Authorization':
          'Bearer 2|POJ0t11nnwFYVsKHrbgcQwdZJ8mwg96M4uuAeWyd4cfcb472'
    };
    var request =
        http.Request('DELETE', Uri.parse('$baseUrl/product-sales/$id'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      emit(ProductSaleDeleted());
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
