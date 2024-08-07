import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceCard extends StatelessWidget {
  final int? balance;
  final bool hasError;
  final Function() onRefreshBalance;
  const BalanceCard(
      {super.key,
      required this.hasError,
      required this.onRefreshBalance,
      this.balance});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFFF8F0D4),
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -100,
              right: -50,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                height: 160,
                width: 160,
                decoration: BoxDecoration(
                    color: colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(100)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Dompet Penghasilanmu",
                    style: textTheme.bodyLarge,
                  ),
                  Row(
                    children: [
                      Text(
                        hasError || balance == null
                            ? "-"
                            : NumberFormat.currency(
                                    locale: 'id',
                                    symbol: 'Rp',
                                    decimalDigits: 0)
                                .format(balance),
                        style: textTheme.headlineMedium,
                      ),
                      GestureDetector(
                          onTap: onRefreshBalance,
                          child: Icon(
                            Icons.refresh,
                            color: colorScheme.onSurface,
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  OutlinedButton(
                      onPressed: () {}, child: const Text("Lihat Detail"))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
