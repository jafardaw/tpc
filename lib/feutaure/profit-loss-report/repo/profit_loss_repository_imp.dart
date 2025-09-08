import 'package:dio/dio.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/feutaure/profit-loss-report/data/model/profit_loss_report_model.dart';
import '../../../../core/util/error/error_handling.dart';

class ProfitLossRepositoryImp {
  final ApiService _apiService;

  ProfitLossRepositoryImp(this._apiService);

  Future<List<ProfitLossReportModel>> getProfitLossReport() async {
    try {
      final response = await _apiService.get('profit-loss-report');
      if (response.data != null && response.data['data'] is List) {
        return (response.data['data'] as List)
            .map((item) => ProfitLossReportModel.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw ErrorHandler.handleDioError(e);
    } catch (e) {
      throw Exception('فشل في جلب تقرير الأرباح والخسائر: $e');
    }
  }
}
