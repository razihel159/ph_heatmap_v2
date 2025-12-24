class DrillDownController {
  static String getFolderByLevel(String level) {
    switch (level) {
      case 'region':
        return 'regions.0.001.json'; // Direct file access
      case 'province':
        return 'provdists_lowres/';
      case 'municity':
        return 'municties_lowres/';
      case 'barangay':
        return 'barangays_lowres/';
      default:
        return 'regions.0.001.json'; // Default to regions kung wala ang country
    }
  }
}