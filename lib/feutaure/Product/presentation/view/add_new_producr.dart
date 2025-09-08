import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tcp212/core/util/apiservice.dart';
import 'package:tcp212/core/util/func/alert_dilog.dart';
import 'package:tcp212/core/util/styles.dart';
import 'package:tcp212/core/widget/appar_widget,.dart';
import 'package:tcp212/core/widget/custom_field.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/add_cubit/add_product_cubit.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/add_cubit/add_product_state.dart';
import 'package:tcp212/feutaure/Product/presentation/view/manager/get_cubit/get_all_product_cubit.dart';
import 'package:tcp212/feutaure/Product/presentation/view/widget/add_new_product_only_semi.dart';
import 'package:tcp212/feutaure/Product/repo/repo_product.dart';
import 'package:tcp212/feutaure/Row_Material/data/get_raw_material_model.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_cubit.dart';
import 'package:tcp212/feutaure/Row_Material/presentation/view/manager/cubit_get/get_raw_material_state.dart';

class MaterialComponent {
  GetRawMaterialModel? selectedMaterial;
  TextEditingController quantityController = TextEditingController();

  MaterialComponent({this.selectedMaterial});
}

class AddNewProduct extends StatelessWidget {
  const AddNewProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddNewProductCubit(
        rawMaterialRepository: ProductListRepo(ApiService()),
      ),
      child: const AddNewProductBody(),
    );
  }
}

class AddNewProductBody extends StatefulWidget {
  const AddNewProductBody({super.key});

  @override
  State<AddNewProductBody> createState() => _AddNewProductBodyState();
}

class _AddNewProductBodyState extends State<AddNewProductBody> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _minimumStockAlertController =
      TextEditingController();
  final TextEditingController _weightPerUnitController =
      TextEditingController();

  String? _selectedMaterialType;
  final List<String> _materialTypes = ['direct_raw', 'semi_raw'];

  // 🚀 القائمة الديناميكية للمواد المكونة
  final List<MaterialComponent> _materials = [MaterialComponent()];

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      if (_selectedMaterialType == 'semi_raw' &&
          _weightPerUnitController.text != '1') {
        return showCustomAlertDialog(
          context: context,
          title: 'jp`dv',
          content: 'you should enter weight 1 when type semi_raw',
        );
      }

      double totalQuantity = 0;
      for (var component in _materials) {
        totalQuantity +=
            double.tryParse(component.quantityController.text) ?? 0;
      }
      double weightPerUnit =
          double.tryParse(_weightPerUnitController.text) ?? 0;

      if (totalQuantity != weightPerUnit) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('⚖️ مجموع كميات المواد يجب أن يساوي وزن القطعة!'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      // ///////هون طريقه تانيه اقصر بدل من التحتا اي بدال الfor

      // List<Map<String, dynamic>> materialsList = _materials.map((component) {
      //   return {
      //     "component_id": component.selectedMaterial!.rawMaterialId,
      //     "quantity_required_per_unit":
      //         double.tryParse(component.quantityController.text),
      //   };
      // }).toList();

      List<Map<String, dynamic>> materialsList = [];
      for (var component in _materials) {
        materialsList.add({
          "component_id": component.selectedMaterial!.rawMaterialId,
          "quantity_required_per_unit": double.tryParse(
            component.quantityController.text,
          ),
        });
      }

      final newProductBody = {
        "name": _nameController.text,
        "category": _selectedMaterialType,
        "weight_per_unit": weightPerUnit,
        "minimum_stock_alert": int.tryParse(_minimumStockAlertController.text),
        "materials": materialsList,
      };

      print('Payload جاهز للإرسال: $newProductBody');

      context.read<AddNewProductCubit>().addNewProduct(newProductBody);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _minimumStockAlertController.dispose();
    _weightPerUnitController.dispose();
    for (var material in _materials) {
      material.quantityController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AppareWidget(
          automaticallyImplyLeading: true,
          title: 'إضافة منتج جديد',
        ),
      ),
      body: BlocBuilder<GetRawMaterialsCubit, GetRawMaterialsState>(
        builder: (context, state) {
          if (state is GetRawMaterialsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is GetRawMaterialsSuccess) {
            final allRawMaterials = state.rawMaterials;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // 📝 بيانات المنتج الأساسية
                    Row(
                      children: [
                        Text(
                          'اضافه ماده نصف مصنعه فقط -->  ',
                          style: Styles.textStyle14,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddNewProductOnlySemi(),
                              ),
                            );
                          },
                          child: Text(
                            'اضغط هنا',
                            style: Styles.textStyle14.copyWith(
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            CustomTextField(
                              controller: _nameController,
                              labelText: 'اسم المنتج',
                              hintText: 'أدخل اسم المنتج',
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'الرجاء إدخال اسم المنتج'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            DropdownButtonFormField<String>(
                              initialValue: _selectedMaterialType,
                              decoration: const InputDecoration(
                                labelText: 'نوع المادة',
                                border: OutlineInputBorder(),
                              ),
                              hint: const Text('اختر نوع المادة'),
                              items: _materialTypes
                                  .map(
                                    (String type) => DropdownMenuItem<String>(
                                      value: type,
                                      child: Text(type),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedMaterialType = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء اختيار نوع المادة';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _minimumStockAlertController,
                              labelText: 'أقل كمية للتنبيه',
                              hintText: 'أدخل أقل كمية للتنبيه',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'الرجاء إدخال أقل كمية للتنبيه'
                                  : null,
                            ),
                            const SizedBox(height: 16.0),
                            CustomTextField(
                              controller: _weightPerUnitController,
                              labelText: 'وزن القطعة الواحدة',
                              hintText: 'أدخل وزن القطعة',
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'الرجاء إدخال وزن القطعة'
                                  : null,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 24.0),
                    const Text(
                      '🧩 المواد المكونة:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),

                    // 🧩 قائمة المواد المكونة
                    ..._materials.asMap().entries.map((entry) {
                      int index = entry.key;
                      MaterialComponent component = entry.value;

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: DropdownButtonFormField<GetRawMaterialModel>(
                                  initialValue: component.selectedMaterial,
                                  decoration: const InputDecoration(
                                    labelText: 'المادة',
                                    border: OutlineInputBorder(),
                                  ),
                                  hint: const Text('اختر المادة'),
                                  // items: allRawMaterials
                                  //     .map((material) =>
                                  //         DropdownMenuItem<GetRawMaterialModel>(
                                  //           value: material,
                                  //           child: Text(material.name ?? ''),
                                  //         ))
                                  //     .toList(),
                                  items: allRawMaterials
                                      .where((material) {
                                        // تحقق إذا المادة موجودة في أي سطر آخر
                                        for (var comp in _materials) {
                                          if (comp != component &&
                                              comp
                                                      .selectedMaterial
                                                      ?.rawMaterialId ==
                                                  material.rawMaterialId) {
                                            return false; // المادة مكررة، لا تظهر
                                          }
                                        }
                                        return true; // المادة لم تُختَر بعد، تظهر
                                      })
                                      .map(
                                        (material) =>
                                            DropdownMenuItem<
                                              GetRawMaterialModel
                                            >(
                                              value: material,
                                              child: Text(material.name ?? ''),
                                            ),
                                      )
                                      .toList(),
                                  onChanged: (GetRawMaterialModel? newValue) {
                                    setState(() {
                                      component.selectedMaterial = newValue;
                                    });
                                  },
                                  validator: (value) {
                                    if (value == null) {
                                      return 'اختر مادة';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              Expanded(
                                flex: 1,
                                child: CustomTextField(
                                  controller: component.quantityController,
                                  labelText: 'الكمية',
                                  hintText: '0',
                                  keyboardType: TextInputType.number,
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        double.tryParse(value) == null ||
                                        double.parse(value) <= 0) {
                                      return 'أدخل كمية صحيحة';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              if (_materials.length > 1)
                                // IconButton(
                                //   icon: const Icon(
                                //     Icons.remove_circle,
                                //     color: Colors.red,
                                //     size: 28,
                                //   ),
                                //   onPressed: () {
                                //     setState(() {
                                //       component.quantityController.dispose();
                                //       _materials.removeAt(index);
                                //     });
                                //   },
                                // ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      component.quantityController.dispose();
                                      _materials.removeAt(index);
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_circle,
                                    color: Colors.red,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const SizedBox(height: 12.0),
                    Center(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            _materials.add(MaterialComponent());
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة مادة مكونة'),
                      ),
                    ),

                    const SizedBox(height: 24.0),
                    BlocConsumer<AddNewProductCubit, AddNewProductState>(
                      listener: (context, addState) {
                        if (addState is AddNewProductSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('✅ ${addState.message}'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          Navigator.of(context).pop();
                          context.read<ProductListCubit>().fetchProducts();
                          // يمكنك العودة للصفحة السابقة
                        } else if (addState is AddNewProductFailure) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ فشل: ${addState.errMessage}'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      builder: (context, addState) {
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: addState is AddNewProductLoading
                              ? null // ⛔️ تعطيل الزر عند التحميل
                              : _saveProduct,
                          child: addState is AddNewProductLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  '💾 حفظ المنتج',
                                  style: TextStyle(fontSize: 16),
                                ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is GetRawMaterialsError) {
            return Center(child: Text('حدث خطأ: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
