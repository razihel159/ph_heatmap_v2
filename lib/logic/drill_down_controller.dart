class DrillDownController {
  static String getFolderByLevel(String level) {
    switch (level) {
      case 'region': return ''; 
      case 'province': return 'provdists_lowres/';
      case 'municipality': return 'municties_lowres/';
      case 'barangay': return 'barangays_lowres/';
      default: return '';
    }
  }

  static Map<String, String>? getNextLevel(String currentLevel) {
    switch (currentLevel) {
      case 'region':
        return {'name': 'province', 'path': 'provdists_lowres/'};
      case 'province':
        return {'name': 'municipality', 'path': 'municties_lowres/'};
      case 'municipality':
        return {'name': 'barangay', 'path': 'barangays_lowres/'};
      default:
        return null;
    }
  }

  static double getZoomLevel(String currentLevel) {
    switch (currentLevel) {
      case 'region': return 8.0;
      case 'province': return 10.0;
      case 'municipality': return 12.0;
      case 'barangay': return 14.0;
      default: return 7.0;
    }
  }
}