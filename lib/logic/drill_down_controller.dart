class DrillDownController {
  static String getFolderByLevel(String level) {
    switch (level) {
      case 'region':
        return 'regions_lowres/';
      case 'province':
        return 'provdists_lowres/';
      case 'municity':
        return 'municties_lowres/';
      case 'barangay':
        return 'barangays_lowres/';
      default:
        return 'country_lowres/';
    }
  }
}