import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/feutaure/ProductSaleReports/presentation/manger/cubit/cubit/product_summary_report_state.dart';
import 'package:tcp212/feutaure/ProductSaleReports/repo/product_summary_repository_imp.dart';

class ProductSummaryReportCubit extends Cubit<ProductSummaryReportState> {
  final ProductSummaryRepositoryImp _productSummaryRepository;

  ProductSummaryReportCubit(this._productSummaryRepository)
    : super(ProductSummaryReportInitial());

  Future<void> fetchProductSummaryReports() async {
    emit(ProductSummaryReportLoading());
    try {
      final reports = await _productSummaryRepository
          .getProductSummaryReports();
      emit(ProductSummaryReportLoaded(reports));
    } catch (e) {
      emit(ProductSummaryReportError(e.toString()));
    }
  }

  Future<void> refreshReports() async {
    // إصدار حالة التحميل
    emit(ProductSummaryReportLoading());
    try {
      // 1. استدعاء دالة التحديث من الـ repository
      await _productSummaryRepository.refreshAllReports();

      // 2. بعد التحديث بنجاح، أعد جلب البيانات الجديدة
      final reports = await _productSummaryRepository
          .getProductSummaryReports();

      // 3. إصدار حالة البيانات المحملة
      emit(ProductSummaryReportLoaded(reports));
    } catch (e) {
      emit(ProductSummaryReportError(e.toString()));
    }
  }

  Future<void> refreshSingleReport(int reportId) async {
    // يمكنك إصدار حالة تحميل مؤقتة إذا كنت تريد إظهار مؤشر
    // loading لكل تقرير على حدة، أو يمكنك الاكتفاء بإدارة
    // الحالة بعد اكتمال العملية.
    // emit(ProductSummaryReportLoading());

    try {
      await _productSummaryRepository.refreshSingleReport(reportId);

      // بعد التحديث بنجاح، أعد جلب جميع التقارير لتحديث واجهة المستخدم
      final reports = await _productSummaryRepository
          .getProductSummaryReports();
      emit(ProductSummaryReportLoaded(reports));
    } catch (e) {
      // يمكنك التعامل مع الخطأ بطريقة أكثر تحديدًا،
      // مثلاً بإصدار حالة خطأ خاصة بالتقارير الفردية
      emit(ProductSummaryReportError(e.toString()));
    }
  }
}
