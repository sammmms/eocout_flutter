import 'dart:async';

import 'package:eocout_flutter/components/my_searchbar.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SeeAllPage extends StatefulWidget {
  final StreamController<BusinessType?> selectedBusiness;
  const SeeAllPage({super.key, required this.selectedBusiness});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final _searchStream = BehaviorSubject<String>.seeded("");

  @override
  void dispose() {
    _searchStream
        .debounceTime(const Duration(milliseconds: 500))
        .listen((event) {});
    super.dispose();
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
            StreamBuilder(
                stream: _searchStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: Text("Tidak ada data yang ditemukan."));
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return const ListTile(
                          title: Text("Data"),
                        );
                      });
                })
          ],
        ),
      ),
    );
  }
}