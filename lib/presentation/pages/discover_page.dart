import 'package:flutter/material.dart';
import 'package:near_voice/core/widgets/background_image.dart';
import 'package:near_voice/core/widgets/custom_app_bar.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});

  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.purple,
      body: BackgroundImage(
        childWidget: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBar(title: "Keşfe Başla"),
              Text("Map gelecek"),
            ],
          ),
        ),
      ),
    );
  }
}
