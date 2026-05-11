import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/einstellungen_provider.dart';

/// Seite für Kalorien-Einstellungen.
/// Hier kann der Nutzer Daten für den Kalorienrechner ändern.
class KalorienEinstellungenSeite extends StatelessWidget {
  const KalorienEinstellungenSeite({super.key});

  @override
  Widget build(BuildContext context) {
    final einstellungen = context.watch<EinstellungenProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kalorien-Einstellungen'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 16),
          Text(
            'Größe: ${einstellungen.groesse} cm',
            style: const TextStyle(fontSize: 18),
          ),
          Slider(
            value: einstellungen.groesse.toDouble(),
            min: 120,
            max: 220,
            divisions: 100,
            label: einstellungen.groesse.toString(),
            onChanged: (wert) {
              einstellungen.groesseSpeichern(wert.round());
            },
          ),

          const SizedBox(height: 16),

          Text(
            'Zielgewicht: ${einstellungen.zielGewicht.toStringAsFixed(1)} kg',
            style: const TextStyle(fontSize: 18),
          ),
          Slider(
            value: einstellungen.zielGewicht,
            min: 40,
            max: 150,
            divisions: 110,
            label: einstellungen.zielGewicht.toStringAsFixed(1),
            onChanged: (wert) {
              einstellungen.zielGewichtSpeichern(wert);
            },
          ),

          const SizedBox(height: 16),

          SwitchListTile(
            title: const Text('Männlich'),
            subtitle: const Text('Ausschalten = weiblich'),
            value: einstellungen.istMaennlich,
            onChanged: einstellungen.geschlechtSpeichern,
          ),

          const SizedBox(height: 16),

          const Text(
            'Aktivität',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          DropdownButtonFormField<double>(
            initialValue: einstellungen.aktivitaetsFaktor,
            decoration: const InputDecoration(
              labelText: 'Aktivitätslevel',
            ),
            items: const [
              DropdownMenuItem(
                value: 1.2,
                child: Text('Wenig Bewegung – Büro, kaum Sport'),
              ),
              DropdownMenuItem(
                value: 1.4,
                child: Text('Leicht aktiv – etwas Bewegung'),
              ),
              DropdownMenuItem(
                value: 1.6,
                child: Text('Aktiv – Sport 2–4x pro Woche'),
              ),
              DropdownMenuItem(
                value: 1.8,
                child: Text('Sehr aktiv – viel Sport/Arbeit'),
              ),
            ],
                        
            onChanged: (wert) {
              if (wert == null) return;
              einstellungen.aktivitaetsFaktorSpeichern(wert);
            },
          ),
          const SizedBox(height: 8),

          const Text(
           'Die Aktivität beeinflusst deinen Tagesbedarf. Je aktiver du bist, desto mehr Kalorien verbraucht dein Körper.',
            style: TextStyle(
            fontSize: 13,
            color: Colors.grey,
            ),
          ),            
        ],
      ),
    );
  }
}