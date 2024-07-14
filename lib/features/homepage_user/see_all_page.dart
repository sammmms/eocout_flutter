import 'dart:async';

import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/bloc/service/service_state.dart';
import 'package:eocout_flutter/components/my_searchbar.dart';
import 'package:eocout_flutter/features/homepage_user/widget/business_card.dart';
import 'package:eocout_flutter/models/business_data.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SeeAllPage extends StatefulWidget {
  final BehaviorSubject<String?> selectedBusiness;
  const SeeAllPage({super.key, required this.selectedBusiness});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final _searchStream = BehaviorSubject<String>.seeded("");
  final _serviceBloc = ServiceBloc();

  @override
  void initState() {
    final String? categoryId = widget.selectedBusiness.valueOrNull;
    _serviceBloc.getServices(categoryId: categoryId!);
    _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            Row(
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
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<ServiceState>(
                stream: _serviceBloc.stream,
                builder: (context, snapshot) {
                  bool isLoading =
                      snapshot.data?.isLoading ?? false || !snapshot.hasData;

                  if (isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  bool hasError = snapshot.data?.hasError ?? false;

                  if (hasError) {
                    return const Center(
                      child: Text("Terjadi kesalahan"),
                    );
                  }

                  List<BusinessData> businessData =
                      snapshot.data?.businessData ?? [];

                  if (businessData.isEmpty) {
                    return const Center(
                      child: Text("Data tidak ditemukan"),
                    );
                  }

                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: businessData.length,
                      itemBuilder: (context, index) {
                        BusinessData data = businessData[index];
                        return BusinessCard(businessData: data);
                      });
                })
          ],
        ),
      ),
    );
  }
}
