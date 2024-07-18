import 'package:eocout_flutter/bloc/notification/notification_bloc.dart';
import 'package:eocout_flutter/bloc/notification/notification_state.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/components/my_no_data_component.dart';
import 'package:eocout_flutter/features/notification/widget/notification_card.dart';
import 'package:eocout_flutter/models/notification_data.dart';
import 'package:eocout_flutter/utils/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    _notificationBloc = context.read<NotificationBloc>();
    Store.saveLastSeenNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(Icons.arrow_back),
          ),
          title: const Text("Notifikasi"),
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        body: Center(
            child: StreamBuilder<NotificationState>(
          stream: _notificationBloc.stream,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.data?.isLoading ?? false || !snapshot.hasData;

            bool hasError = snapshot.data?.hasError ??
                false || snapshot.data?.error != null;

            if (hasError) {
              return MyErrorComponent(
                onRefresh: () {
                  _notificationBloc.fetchNotifications();
                },
                error: snapshot.data?.error,
              );
            }

            List<NotificationData> notificationData =
                snapshot.data?.notificationList ??
                    List.generate(10, (_) => NotificationData.dummy());

            if (notificationData.isEmpty) {
              return const MyNoDataComponent(
                label: "Tidak ada notifikasi",
              );
            }

            return Skeletonizer(
              enabled: isLoading,
              child: RefreshIndicator(
                onRefresh: () async {
                  await _notificationBloc.fetchNotifications();
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  itemCount: notificationData.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    NotificationData data = notificationData[index];
                    return NotificationCard(data: data);
                  },
                ),
              ),
            );
          },
        )));
  }
}
