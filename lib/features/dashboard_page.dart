import 'package:collection/collection.dart';
import 'package:eocout_flutter/features/homepage/home_page.dart';
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
        return SvgPicture.asset('assets/svg/dashboard.svg');
      case NavigationItem.addEvent:
        return SvgPicture.asset('assets/svg/add_event.svg');
      case NavigationItem.cart:
        return SvgPicture.asset('assets/svg/cart.svg');
      case NavigationItem.chat:
        return SvgPicture.asset('assets/svg/chat.svg');
      default:
        return SvgPicture.asset('assets/svg/dashboard.svg');
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
  List<NavigationItem> pageItem = [
    NavigationItem.dashboard,
    NavigationItem.addEvent,
    NavigationItem.cart,
    NavigationItem.chat
  ];

  @override
  void initState() {
    user = context.read<UserData>();
    if (user.role != UserRole.eventOrganizer) {
      pageItem.remove(NavigationItem.addEvent);
    }
    _pageController.addListener(() {
      if (_selectedPage.value != _pageController.page!.round()) {
        _selectedPage.add(_pageController.page!.round());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: [
            const Homepage(),
            if (user.role == UserRole.eventOrganizer)
              const Center(child: Text('Add Event')),
            const Center(child: Text('Cart')),
            const Center(child: Text('Chat')),
          ],
        ),
        resizeToAvoidBottomInset: false,
        bottomSheet: SafeArea(
          maintainBottomViewPadding: true,
          minimum: EdgeInsets.zero,
          child: Container(
            margin: EdgeInsets.zero,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
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
                      selectedLabelStyle: textStyle.headlineLarge,
                      type: BottomNavigationBarType.fixed,
                      elevation: 0,
                      items: pageItem
                          .mapIndexed(
                            (index, item) => BottomNavigationBarItem(
                              icon: SizedBox(
                                height: 32,
                                width: 32,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
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
        ));
  }
}
