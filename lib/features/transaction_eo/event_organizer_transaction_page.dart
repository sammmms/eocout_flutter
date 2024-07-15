import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class EventOrganizerTransactionPage extends StatelessWidget {
  const EventOrganizerTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Status Pemesanan")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildFilterButton(
                  label: "Pesanan Baru",
                  svgAsset: "assets/svg/order_new_icon.svg",
                  onTap: () {},
                ),
                _buildFilterButton(
                  label: "Diproses",
                  svgAsset: "assets/svg/order_process_icon.svg",
                  onTap: () {},
                ),
                _buildFilterButton(
                  label: "Selesai",
                  svgAsset: "assets/svg/order_done_icon.svg",
                  onTap: () {},
                ),
                _buildFilterButton(
                  label: "Dibatalkan",
                  svgAsset: "assets/svg/order_cancel_icon.svg",
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              "Info Pembayaran",
              style: textTheme.headlineSmall,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton({
    required String label,
    required String svgAsset,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF141E46),
              borderRadius: BorderRadius.circular(15),
            ),
            child: SvgPicture.asset(
              svgAsset,
              width: 30,
              height: 30,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
