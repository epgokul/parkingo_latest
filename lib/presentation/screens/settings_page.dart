import 'package:flutter/material.dart';
import 'package:new_parkingo/presentation/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    bool switchValue = Provider.of<ThemeProvider>(context).isDarkTheme;

    void toggleTheme(bool value) {
      Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
      setState(() {
        switchValue = value;
      });
    }

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 20.0, right: 20),
        child: Column(
          children: [
            RowElement(
                text: "text",
                widget: Switch(
                  value: switchValue,
                  onChanged: (value) {
                    toggleTheme(value);
                  },
                ))
          ],
        ),
      ),
    );
  }
}

class RowElement extends StatelessWidget {
  final String text;
  final Widget widget;
  const RowElement({super.key, required this.text, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [const Text("Dark Mode"), widget],
    );
  }
}
