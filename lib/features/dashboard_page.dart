import 'package:collection/collection.dart';
import 'package:eocout_flutter/bloc/authentication/authentication_bloc.dart';
import 'package:eocout_flutter/bloc/profile/profile_bloc.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:eocout_flutter/components/my_transition.dart';
import 'package:eocout_flutter/features/authentication/register/otp_page.dart';
import 'package:eocout_flutter/features/profile/eo_edit_detail_page.dart';
import 'package:eocout_flutter/features/create_service/create_service_page.dart';
import 'package:eocout_flutter/features/chat_page/chat_page.dart';
import 'package:eocout_flutter/features/homepage_eo/event_organizer_home_page.dart';
import 'package:eocout_flutter/features/homepage_user/user_home_page.dart';
import 'package:eocout_flutter/features/transaction_eo/event_organizer_transaction_page.dart';
import 'package:eocout_flutter/features/transaction_user/user_transaction_page.dart';
import 'package:eocout_flutter/features/welcome_page.dart';
import 'package:eocout_flutter/models/user_data.dart';
import 'package:eocout_flutter/utils/role_type_util.dart';
import 'package:eocout_flutter/utils/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

enum NavigationItem { dashboard, addEvent, cart, chat }

class NavigationItemUtil {
  static const Map<NavigationItem, String> itemNames = {
    NavigationItem.dashboard: 'Dashboard',
    NavigationItem.addEvent: 'Add Event',
    NavigationItem.cart: 'Cart',
    NavigationItem.chat: 'Chat',
  };

  static SvgPicture iconsOf(NavigationItem item) {
    switch (item) {
      case NavigationItem.dashboard:
        return SvgPicture.asset('assets/svg/dashboard_icon.svg');
      case NavigationItem.addEvent:
        return SvgPicture.asset('assets/svg/add_event_icon.svg');
      case NavigationItem.cart:
        return SvgPicture.asset('assets/svg/cart_icon.svg');
      case NavigationItem.chat:
        return SvgPicture.asset('assets/svg/chat_icon.svg');
      default:
        return SvgPicture.asset('assets/svg/dashboard_icon.svg');
    }
  }
}

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _selectedPage = BehaviorSubject<int>.seeded(0);
  final _pageController = PageController(initialPage: 0);
  late UserData user;
  late AuthBloc bloc;
  List<NavigationItem> pageItem = [
    NavigationItem.dashboard,
    NavigationItem.addEvent,
    NavigationItem.cart,
    NavigationItem.chat
  ];

  @override
  void initState() {
    bloc = context.read<AuthBloc>();
    user =
        bloc.stream.value.user ?? UserData.dummy(role: UserRole.eventOrganizer);

    // Check for profile data validity

    WidgetsBinding.instance.addPostFrameCallback((_) {
      UserData? userData =
          context.read<ProfileBloc>().controller.valueOrNull?.profile;

      if (userData == null) {
        showMySnackBar(
            context,
            "Terjadi kesalahan autentikasi, harap login kembali.",
            SnackbarStatus.error);
        navigateTo(context, const WelcomePage(),
            transition: TransitionType.slideInFromBottom, clearStack: true);
        return;
      }

      bool isEmailVerified = user.isEmailVerified;

      if (!isEmailVerified) {
        showMySnackBar(
            context, "Email kamu belum terverifikasi.", SnackbarStatus.error);
        navigateTo(context, const OtpPage(),
            transition: TransitionType.slideInFromBottom);
        return;
      }

      if (user.role != UserRole.eventOrganizer) {
        pageItem.remove(NavigationItem.addEvent);
      } else {
        bool isRequiredFilled =
            userData.profileData?.isRequiredFilled() ?? false;

        if (!isRequiredFilled || userData.profileData == null) {
          showMySnackBar(context, "Detail bisnis kamu belum lengkap",
              SnackbarStatus.error);
          navigateTo(context, const EOEditDetailDataPage(),
              transition: TransitionType.slideInFromBottom);
          return;
        }
      }
    });

    _pageController.addListener(() {
      if (_selectedPage.value != _pageController.page!.round()) {
        _selectedPage.add(_pageController.page!.round());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PageController>.value(value: _pageController),
      ],
      child: Scaffold(
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              if (user.role == UserRole.user)
                const Homepage()
              else
                const EventOrganizerHomePage(),
              if (user.role == UserRole.eventOrganizer) const AddEventPage(),
              if (user.role == UserRole.user)
                const UserTransactionPage()
              else
                const EventOrganizerTransactionPage(),
              const ChatPage(),
            ],
          ),
          resizeToAvoidBottomInset: false,
          bottomSheet: SafeArea(
            maintainBottomViewPadding: true,
            minimum: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              child: Container(
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                  color: colorScheme.primary,
                ),
                child: StreamBuilder<int>(
                    stream: _selectedPage,
                    builder: (context, snapshot) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                        ),
                        child: BottomNavigationBar(
                          showUnselectedLabels: false,
                          showSelectedLabels: false,
                          unselectedFontSize: 0,
                          selectedFontSize: 0,
                          selectedLabelStyle: const TextStyle(fontSize: 13),
                          type: BottomNavigationBarType.fixed,
                          elevation: 0,
                          items: pageItem
                              .mapIndexed(
                                (index, item) => BottomNavigationBarItem(
                                  icon: SizedBox(
                                    height: 32,
                                    width: 32,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        NavigationItemUtil.iconsOf(item),
                                        const SizedBox(height: 5),
                                        if (snapshot.data == index) ...[
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(1000),
                                                color: colorScheme.onPrimary),
                                            height: 5,
                                            width: 5,
                                          )
                                        ]
                                      ],
                                    ),
                                  ),
                                  label: "",
                                ),
                              )
                              .toList(),
                          currentIndex: _selectedPage.value,
                          onTap: (index) async {
                            await _pageController.animateToPage(index,
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeOutCubic);
                          },
                        ),
                      );
                    }),
              ),
            ),
          )),
    );
  }
}
