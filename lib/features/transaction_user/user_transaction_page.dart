import 'package:flutter/material.dart';

class UserTransactionPage extends StatefulWidget {
  const UserTransactionPage({super.key});

  @override
  State<UserTransactionPage> createState() => _UserTransactionPageState();
}

class _UserTransactionPageState extends State<UserTransactionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informasi Pembayaran'),
      ),
      body: Column(
        children: [
          TabBar(
            controller: _tabController,
            dividerColor: Colors.transparent,
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            tabs: const [
              Tab(
                text: 'Belum Dibayar',
              ),
              Tab(
                text: 'Sudah Dibayar',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                Text('Belum Dibayar'),
                Text('Sudah Dibayar'),
              ],
            ),
          )
        ],
      ),
    );
  }
}
