import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final String url;
  final double height;
  final double borderRadius;

  const AppButton({
    super.key,
    required this.label,
    required this.icon,
    required this.url,
    required this.height,
    required this.borderRadius,
  });

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Tidak dapat membuka URL $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: _launchUrl,
        icon: Icon(icon),
        label: Text(label), // Text biasa tanpa properti style
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
      ),
    );
  }
}
