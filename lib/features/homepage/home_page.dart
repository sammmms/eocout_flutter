import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/features/homepage/widgets/explore_list.dart';
import 'package:eocout_flutter/features/homepage/see_all_page.dart';
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
  late AuthBloc bloc;

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    bloc.refreshProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder<BusinessType>(
          stream: _selectedBusiness,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SeeAllPage(selectedBusiness: snapshot.data!);
            }
            return ExploreList(selectedBusiness: _selectedBusiness);
          }),
    ));
  }
}
