import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/components/my_homepage_appbar.dart';
import 'package:eocout_flutter/utils/business_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ExploreList extends StatelessWidget {
  final BehaviorSubject<BusinessType?> selectedBusiness;
  const ExploreList({super.key, required this.selectedBusiness});

  @override
  Widget build(BuildContext context) {
    AuthBloc bloc = context.read<AuthBloc>();
    return RefreshIndicator(
      onRefresh: () async {
        await bloc.refreshProfile();
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          children: [
            const MyHomepageAppBar(),
            const SizedBox(
              height: 20,
            ),
            ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      selectedBusiness.add(BusinessType.values[index]);
                    },
                    child: Card(
                      child: Container(
                          height: 200,
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                  colorFilter: ColorFilter.mode(
                                      Colors.black.withOpacity(0.3),
                                      BlendMode.darken),
                                  image: AssetImage(BusinessTypeUtil.imageOf(
                                      BusinessType.values[index])),
                                  fit: BoxFit.cover)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lihat Semua",
                                style: textStyle.bodyLarge!
                                    .copyWith(color: colorScheme.onPrimary),
                              ),
                              Text(
                                BusinessTypeUtil.textOf(
                                    BusinessType.values[index]),
                                style: textStyle.headlineLarge!
                                    .copyWith(color: colorScheme.onPrimary),
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
                itemCount: BusinessType.values.length),
          ],
        ),
      ),
    );
  }
}
