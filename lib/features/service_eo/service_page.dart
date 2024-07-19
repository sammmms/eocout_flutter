import 'package:eocout_flutter/bloc/service/service_bloc.dart';
import 'package:eocout_flutter/components/my_error_component.dart';
import 'package:eocout_flutter/features/homepage_user/widget/service_card.dart';
import 'package:eocout_flutter/models/service_data.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ServicePage extends StatefulWidget {
  const ServicePage({super.key});

  @override
  State<ServicePage> createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final ServiceBloc bloc = ServiceBloc();

  @override
  void initState() {
    bloc.getOwnService();
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
        title: const Text("Layanan Kamu"),
      ),
      body: StreamBuilder(
          stream: bloc.stream,
          builder: (context, snapshot) {
            bool isLoading =
                snapshot.data?.isLoading ?? false || !snapshot.hasData;

            bool hasError = snapshot.data?.hasError ?? false;

            if (hasError) {
              return MyErrorComponent(
                onRefresh: () {
                  bloc.getOwnService();
                },
                error: snapshot.data?.error,
              );
            }

            List<ServiceData> services = snapshot.data?.serviceData ??
                List.generate(10, (_) => ServiceData.dummy());

            return Skeletonizer(
                enabled: isLoading,
                child: ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    itemCount: services.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      ServiceData serviceData = services[index];
                      return ServiceCard(serviceData: serviceData);
                    }));
          }),
    );
  }
}
