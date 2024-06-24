import 'package:eocout_flutter/components/my_searchbar.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SeeAllPage extends StatefulWidget {
  final BusinessType selectedBusiness;
  const SeeAllPage({super.key, required this.selectedBusiness});

  @override
  State<SeeAllPage> createState() => _SeeAllPageState();
}

class _SeeAllPageState extends State<SeeAllPage> {
  final _searchStream = BehaviorSubject<String>.seeded("");

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MySearchBar(
              isRounded: true,
              onChanged: (value) {
                _searchStream.add(value);
              },
              label: "Cari EO atau Vendor yang kamu inginkan!"),
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
    );
  }
}
