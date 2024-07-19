import 'package:eocout_flutter/bloc/category/category_bloc.dart';
import 'package:eocout_flutter/bloc/category/category_state.dart';
import 'package:eocout_flutter/utils/service_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class MyBusinessCategoryDropdown extends StatefulWidget {
  final String? selectedBusinessId;
  final Function(ServiceType? businessType, String? id) onChanged;
  const MyBusinessCategoryDropdown(
      {super.key, this.selectedBusinessId, required this.onChanged});

  @override
  State<MyBusinessCategoryDropdown> createState() =>
      _MyBusinessCategoryDropdownState();
}

class _MyBusinessCategoryDropdownState
    extends State<MyBusinessCategoryDropdown> {
  ServiceType? selectedBusiness;
  final _categoryBloc = CategoryBloc();

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _categoryBloc.getCategories();
      if (widget.selectedBusinessId != null) {
        List<EOCategory>? categories = _categoryBloc.state?.categories;

        if (categories != null) {
          final category = categories
              .firstWhere((element) => element.id == widget.selectedBusinessId);
          setState(() {
            selectedBusiness = category.serviceType;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _categoryBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CategoryState>(
        stream: _categoryBloc.stream,
        builder: (context, snapshot) {
          bool isLoading =
              snapshot.data?.isLoading ?? false || !snapshot.hasData;
          List<EOCategory> categories = snapshot.data?.categories ?? [];
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: colorScheme.outline,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            height: 55,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: isLoading
                ? const Center(child: Text("Memuat kategori..."))
                : DropdownButtonHideUnderline(
                    child: DropdownButton(
                      borderRadius: BorderRadius.circular(20),
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down),
                      items: categories
                          .map((category) => DropdownMenuItem(
                                value: category.serviceType,
                                child: Text(ServiceTypeUtil.textOf(
                                    category.serviceType)),
                              ))
                          .toList(),
                      onChanged: (ServiceType? value) {
                        setState(() {
                          selectedBusiness = value;
                          widget.onChanged(
                              value,
                              categories
                                  .firstWhere(
                                      (element) => element.serviceType == value)
                                  .id);
                        });
                      },
                      hint: const Text("Pilih Kategori"),
                      value: selectedBusiness,
                    ),
                  ),
          );
        });
  }
}
