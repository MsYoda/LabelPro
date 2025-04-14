import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:label_pro_client/navigation/router.gr.dart';

import '../../tagging/widgets/menu_button.dart';

@RoutePage()
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _currentRootName = TaggingRoute.name;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Row(
        children: [
          Container(
            clipBehavior: Clip.none,
            width: 250,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    "LabelPro",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                MenuButton(
                  isSelected: _currentRootName == TaggingRoute.name,
                  onPressed: () {
                    setState(() {
                      _currentRootName = TaggingRoute.name;
                    });
                    context.navigateTo(TaggingRoute());
                  },
                  title: 'Tagging',
                  icon: Icons.home_repair_service_outlined,
                ),
                MenuButton(
                  isSelected: _currentRootName == SettingsRoute.name,
                  onPressed: () {
                    setState(() {
                      _currentRootName = SettingsRoute.name;
                    });
                    context.navigateTo(SettingsRoute());
                  },
                  title: 'Settings',
                  icon: Icons.bar_chart,
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AutoRouter(),
            ),
          ),
        ],
      ),
    );
  }
}
