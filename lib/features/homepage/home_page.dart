import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/features/homepage/widgets/explore_list.dart';
import 'package:eocout_flutter/features/homepage/see_all_page.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _selectedBusiness = BehaviorSubject<BusinessType>();
  late UserData user;

  @override
  void initState() {
    user = context.read<AuthBloc>().stream.value.user!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 100),
          child: StreamBuilder<BusinessType>(
              stream: _selectedBusiness,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SeeAllPage(selectedBusiness: snapshot.data!);
                }
                return ExploreList(selectedBusiness: _selectedBusiness);
              })),
    ));
  }
}
