import 'dart:math';

class DataService {
  static int getUserCountForArea(String pCode, String level) {
    if (pCode.isEmpty) return 0;
    final int seed = pCode.hashCode;
    final random = Random(seed);
    
    switch (level) {
      case 'region':
        return 800 + random.nextInt(9500); 
      case 'province':
        return 400 + random.nextInt(4601);  
      case 'municipality':
        return 50 + random.nextInt(951);   
      case 'barangay':
        return 1 + random.nextInt(50);      
      default:
        return random.nextInt(100);
    }
  }
}