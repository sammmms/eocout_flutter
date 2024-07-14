import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/category/category_bloc.dart';
import 'package:eocout_flutter/features/homepage_user/explore_list.dart';
import 'package:eocout_flutter/features/homepage_user/see_all_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _selectedBusiness = BehaviorSubject<String?>();
  final CategoryBloc _categoryBloc = CategoryBloc();
  late AuthBloc bloc;

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    bloc.refreshProfile();
    _categoryBloc.getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: StreamBuilder<String?>(
          stream: _selectedBusiness,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SeeAllPage(selectedBusiness: _selectedBusiness);
            }
            return Provider<CategoryBloc>.value(
                value: _categoryBloc,
                child: ExploreList(
                  selectedBusiness: _selectedBusiness,
                ));
          }),
    ));
  }
}
