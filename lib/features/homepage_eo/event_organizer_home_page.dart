import 'package:eocout_flutter/components/my_homepage_appbar.dart';
import 'package:eocout_flutter/features/homepage_eo/widget/balance_card.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';

class EventOrganizerHomePage extends StatelessWidget {
  const EventOrganizerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const MyHomepageAppBar(),
              const SizedBox(
                height: 40,
              ),
              const BalanceCard(),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Pesanan Hari Ini",
                style: textStyle.headlineMedium,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Pengumuman Mitra",
                style: textStyle.headlineMedium,
              )
            ],
          ),
        ),
      ),
    );
  }
}
