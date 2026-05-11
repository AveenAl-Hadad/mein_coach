/// Modell für das Kalorienprofil.
/// Speichert die Daten, die für den Kalorienrechner gebraucht werden.
class KalorienProfil {
  final int alter;
  final double groesse;
  final double aktuellesGewicht;
  final double zielGewicht;
  final bool istMaennlich;
  final double aktivitaetsFaktor;

  KalorienProfil({
    required this.alter,
    required this.groesse,
    required this.aktuellesGewicht,
    required this.zielGewicht,
    required this.istMaennlich,
    required this.aktivitaetsFaktor,
  });

  Map<String, dynamic> zuJson() {
    return {
      'alter': alter,
      'groesse': groesse,
      'aktuellesGewicht': aktuellesGewicht,
      'zielGewicht': zielGewicht,
      'istMaennlich': istMaennlich,
      'aktivitaetsFaktor': aktivitaetsFaktor,
    };
  }

  factory KalorienProfil.vonJson(Map<String, dynamic> json) {
    return KalorienProfil(
      alter: json['alter'] ?? 18,
      groesse: (json['groesse'] ?? 170).toDouble(),
      aktuellesGewicht: (json['aktuellesGewicht'] ?? 70).toDouble(),
      zielGewicht: (json['zielGewicht'] ?? 65).toDouble(),
      istMaennlich: json['istMaennlich'] ?? true,
      aktivitaetsFaktor: (json['aktivitaetsFaktor'] ?? 1.4).toDouble(),
    );
  }

  factory KalorienProfil.standard() {
    return KalorienProfil(
      alter: 18,
      groesse: 170,
      aktuellesGewicht: 70,
      zielGewicht: 65,
      istMaennlich: true,
      aktivitaetsFaktor: 1.4,
    );
  }
}