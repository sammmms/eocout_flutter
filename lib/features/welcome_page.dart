import 'package:eocout_flutter/components/my_background.dart';
import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/authentication_page.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final pageController = PageController();
  final pageStream = BehaviorSubject<int>.seeded(0);

  @override
  void initState() {
    pageController.addListener(() {
      pageStream.add(pageController.page!.round());
    });
    super.initState();
  }

  @override
  void dispose() {
    pageStream.close();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: MyBackground(
          needPadding: false,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 600,
                child: PageView(
                  controller: pageController,
                  children: [
                    _iconWithHeadline(
                      context,
                      "Temukan EO-mu!",
                      'EO Cout dapat membantu kamu menemukan dan merekomendasikan Event Organizer dan Vendor terbaik disekitaran kamu!',
                    ),
                    _iconWithHeadline(
                      context,
                      "Dapatkan solusi terbaik!",
                      'Dengan Event Organizer dan Vendor terbaik, kami akan membantu kamu mendapatkan solusi terbaik untuk menyelesaikan permasalahan acaramu!',
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _iconWithHeadline(
                            context,
                            "Buat acaramu tak terlupakan!",
                            'Dengan Event Organizer dan Vendor terbaik, kami akan membantu kamu membuat acaramu menjadi tak terlupakan!',
                            Image.asset("assets/images/meeting_logo.png")),
                        const SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: OutlinedButton(
                              onPressed: () {
                                navigateTo(context, const AuthenticationPage(),
                                    transition:
                                        TransitionType.slideInFromBottom);
                              },
                              child: Text(
                                'Mulai',
                                style: textTheme.titleLarge!
                                    .copyWith(color: colorScheme.onPrimary),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder<int>(
                  stream: pageStream,
                  initialData: 0,
                  builder: (context, snapshot) {
                    int currentPage = snapshot.data ?? 0;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _progressBar(currentPage == 0),
                        const SizedBox(
                          width: 10,
                        ),
                        _progressBar(currentPage == 1),
                        const SizedBox(
                          width: 10,
                        ),
                        _progressBar(currentPage == 2),
                      ],
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  Widget _progressBar(bool isTrue) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: isTrue ? colorScheme.secondaryContainer : colorScheme.shadow,
      ),
      height: 10,
      width: 10,
    );
  }

  Widget _iconWithHeadline(
      BuildContext context, String headline, String subheadline,
      [Widget? icon]) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        icon ?? const MyLogo(size: 150),
        const SizedBox(
          height: 30,
        ),
        SizedBox(
          width: 300,
          child: Column(
            children: [
              Text(
                headline,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                subheadline,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
