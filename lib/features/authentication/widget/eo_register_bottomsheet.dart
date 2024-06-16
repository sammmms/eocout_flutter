import 'package:eocout_flutter/components/my_searchbar.dart';
import 'package:eocout_flutter/utils/dummy_data.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class EORegisterBottomsheet extends StatefulWidget {
  final String? province;
  const EORegisterBottomsheet({super.key, this.province});

  @override
  State<EORegisterBottomsheet> createState() => _EORegisterBottomsheetState();
}

class _EORegisterBottomsheetState extends State<EORegisterBottomsheet> {
  final _searchStream = BehaviorSubject<String>.seeded('');
  late List<String> provinces;

  @override
  void initState() {
    provinces = indonesiaProvince.keys.toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.province != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pilih Kota', style: textStyle.headlineSmall),
            const SizedBox(
              height: 15,
            ),
            MySearchBar(
                onChanged: (value) {
                  _searchStream.add(value);
                },
                label: "Cari Kota..."),
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<String>(
                stream: _searchStream,
                builder: (context, snapshot) {
                  List<String> cities = [];
                  if (snapshot.hasData) {
                    cities = indonesiaProvince[widget.province]!
                        .where((element) => element
                            .toLowerCase()
                            .contains(snapshot.data!.toLowerCase()))
                        .toList();
                  }
                  cities.sort();
                  return Expanded(
                    child: Scrollbar(
                      child: ListView.separated(
                        itemCount: cities.length,
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 3,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.pop(context, cities[index]);
                            },
                            child: Card(
                              color: colorScheme.tertiaryContainer
                                  .withOpacity(0.05),
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(cities[index],
                                      style: textStyle.titleMedium)),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Pilih Provinsi', style: textStyle.headlineSmall),
          const SizedBox(
            height: 15,
          ),
          MySearchBar(
              onChanged: (value) {
                _searchStream.add(value);
              },
              label: "Cari Provinsi..."),
          const SizedBox(
            height: 15,
          ),
          StreamBuilder<String>(
              stream: _searchStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  provinces = indonesiaProvince.keys
                      .where((element) => element
                          .toLowerCase()
                          .contains(snapshot.data!.toLowerCase()))
                      .toList();
                }
                provinces.sort();
                return Expanded(
                  child: Scrollbar(
                    child: ListView.separated(
                      itemCount: provinces.length,
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 3,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pop(context, provinces[index]);
                          },
                          child: Card(
                            color:
                                colorScheme.tertiaryContainer.withOpacity(0.05),
                            child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(provinces[index],
                                    style: textStyle.titleMedium)),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}
