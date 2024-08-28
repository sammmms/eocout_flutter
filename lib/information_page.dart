import 'package:eocout_flutter/components/my_logo.dart';
import 'package:eocout_flutter/components/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationPage extends StatelessWidget {
  const InformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Information Page"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const MyLogo(size: 200),
            const Text("Contact us by email at:"),
            const Text("eocoutid@gmail.com"),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  Uri uri = Uri.parse("mailto:eocoutid@gmail.com");
                  await launchUrl(uri);

                  if (!context.mounted) return;

                  Clipboard.setData(
                      const ClipboardData(text: "eocoutid@gmail.com"));

                  showMySnackBar(context, "Email copied to clipboard",
                      SnackbarStatus.success);
                },
                child: const Text("Send Email")),
          ],
        ),
      ),
    );
  }
}
