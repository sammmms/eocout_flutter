import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/category/category_bloc.dart';
import 'package:eocout_flutter/bloc/category/category_state.dart';
import 'package:eocout_flutter/components/my_homepage_appbar.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ExploreList extends StatelessWidget {
  final BehaviorSubject<String?> selectedBusiness;
  const ExploreList({super.key, required this.selectedBusiness});

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = context.read<AuthBloc>();
    CategoryBloc categoryBloc = context.read<CategoryBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        await bloc.refreshProfile();
        await categoryBloc.getCategories();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            const MyHomepageAppBar(),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<CategoryState>(
                stream: categoryBloc.controller,
                builder: (context, snapshot) {
                  bool isLoading =
                      snapshot.data?.isLoading ?? false || !snapshot.hasData;

                  // if(isLoading){
                  //   return
                  // }

                  List<EOCategory> categories = snapshot.data?.categories ??
                      List.generate(7, (_) => EOCategory.dummy());
                  return Skeletonizer(
                    enabled: isLoading,
                    child: ListView.separated(
                      itemCount: categories.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        EOCategory category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            selectedBusiness.add(category.id);
                          },
                          child: Card(
                            child: Container(
                                height: 200,
                                padding:
                                    const EdgeInsets.fromLTRB(20, 20, 20, 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        colorFilter: ColorFilter.mode(
                                            Colors.black.withOpacity(0.3),
                                            BlendMode.darken),
                                        image: AssetImage(
                                            BusinessTypeUtil.imageOf(
                                                category.businessType)),
                                        fit: BoxFit.cover)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Lihat Semua",
                                      style: textStyle.bodyLarge!.copyWith(
                                          color: colorScheme.onPrimary),
                                    ),
                                    Text(
                                      BusinessTypeUtil.textOf(
                                          category.businessType),
                                      style: textStyle.headlineLarge!.copyWith(
                                          color: colorScheme.onPrimary),
                                    ),
                                  ],
                                )),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(
                          height: 10,
                        );
                      },
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
