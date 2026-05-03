import 'package:flutter/material.dart';
import 'package:mein_coach/style/app_style.dart';

/// Wiederverwendbare Karte für Tracking-Werte.
/// Beispiel: Gewicht, Wasser, Schritte.
class TrackingKarte extends StatelessWidget {
  final String titel;
  final String untertitel;
  final IconData? icon;
  final VoidCallback? aktionPlus;
  final VoidCallback? aktionMinus;

  const TrackingKarte({
    super.key,
    required this.titel,
    required this.untertitel,
    this.icon,
    this.aktionPlus,
    this.aktionMinus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: icon == null ? null : Icon(icon),
        title: Text(titel),
        subtitle: Text(untertitel),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (aktionMinus != null)
              IconButton(
                onPressed: aktionMinus,
                icon: AppStyle.gewichtMinus,
              ),
            if (aktionPlus != null)
              IconButton(
                onPressed: aktionPlus,
                icon:AppStyle.wasserIcon,
              ),
          ],
        ),
      ),
    );
  }
}