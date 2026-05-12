/// Service für einfache Wasser-Tipps.
class WasserTippService {
  static String tipp(int gegesseneKalorien) {
    if (gegesseneKalorien >= 2000) {
      return 'Heute genug Wasser trinken, besonders nach vielen Kalorien.';
    }

    if (gegesseneKalorien >= 1000) {
      return 'Ein Glas Wasser vor der nächsten Mahlzeit ist eine gute Idee.';
    }

    return 'Starte den Tag mit Wasser und trinke regelmäßig weiter.';
  }
}