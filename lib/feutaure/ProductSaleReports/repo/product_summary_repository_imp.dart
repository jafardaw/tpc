import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/ProductSaleReports/data/model/monthly_profit_model.dart';
import 'package:tcp212/feutaure/ProductSaleReports/data/model/product_summary_report_model.dart';
import '../../../../core/util/error/error_handling.dart';

class ProductSummaryRepositoryImp {
  final ApiService _apiService;

  ProductSummaryRepositoryImp(this._apiService);

  Future<MonthlyProfitModel> getMonthlyProfit() async {
    try {
      final response = await _apiService.get(
        'product-summary-reports/monthlyProfit',
      );
      if (response.data != null) {
        return MonthlyProfitModel.fromJson(response.data);
      } else {
        throw Exception('الاستجابة لا تحتوي على بيانات لتقرير الربح الشهري.');
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      print(e.toString());
      throw Exception('فشل في جلب الربح الشهري: $e');
    }
  }

  Future<List<ProductSummaryReportModel>> getProductSummaryReports() async {
    try {
      final response = await _apiService.get('product-summary-reports');
      if (response.data != null && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((item) => ProductSummaryReportModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب تقارير ملخص المنتج: $e');
    }
  }

  Future<void> refreshAllReports() async {
    try {
      await _apiService.update(
        'product-summary-reports/refresh-all-reports',
        // يمكنك تمرير بيانات فارغة إذا كانت نقطة النهاية لا تتطلب body
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في تحديث جميع التقارير: $e');
    }
  }

  Future<void> refreshSingleReport(int reportId) async {
    try {
      await _apiService.update(
        'product-summary-reports/refresh-report/$reportId',
      );
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في تحديث التقرير الفردي: $e');
    }
  }
}
