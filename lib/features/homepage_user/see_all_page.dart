import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/components/my_searchbar.dart';
import 'package:eocout_flutter/features/homepage_user/widget/service_card.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SeeAllPage extends StatefulWidget {
  final BehaviorSubject<String?> selectedBusiness;
  const SeeAllPage({super.key, required this.selectedBusiness});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final _searchStream = BehaviorSubject<String>.seeded("");
  final _serviceBloc = ServiceBloc();
  late String? categoryId;

  @override
  void initState() {
    categoryId = widget.selectedBusiness.valueOrNull;
    _serviceBloc.getServices(categoryId: categoryId!);
    _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        widget.selectedBusiness.add(null);
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.selectedBusiness.add(null);
                  },
                  child: const Icon(Icons.arrow_back),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: MySearchBar(
                      isRounded: true,
                      onChanged: (value) {
                        _searchStream.add(value);
                      },
                      label: "Cari EO atau Vendor yang kamu inginkan!"),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _serviceBloc.getServices(categoryId: categoryId!);
              },
              child: StreamBuilder<ServiceState>(
                  stream: _serviceBloc.stream,
                  builder: (context, snapshot) {
                    bool isLoading =
                        snapshot.data?.isLoading ?? false || !snapshot.hasData;

                    bool hasError = snapshot.data?.hasError ?? false;

                    if (hasError) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                        child: MyErrorComponent(onRefresh: () async {
                          await _serviceBloc.getServices(
                              categoryId: categoryId!);
                        }),
                      );
                    }

                    List<ServiceData> businessData =
                        snapshot.data?.serviceData ??
                            List.generate(5, (_) => ServiceData.dummy());

                    if (businessData.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.fromLTRB(20, 20, 20, 80),
                        child: MyNoDataComponent(
                          label: "Tidak ada vendor yang ditemukan",
                        ),
                      );
                    }

                    return Skeletonizer(
                      enabled: isLoading,
                      child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                          itemCount: businessData.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 20,
                              ),
                          itemBuilder: (context, index) {
                            ServiceData data = businessData[index];
                            return ServiceCard(serviceData: data);
                          }),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}
