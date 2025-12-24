import 'dart:math';

class DataService {
  static const int totalPHUsers = 3000; 

  static int getUserCountForArea(String pCode) {
    if (pCode.isEmpty) return 0;
    final int seed = pCode.hashCode;
    final random = Random(seed);
    
    if (pCode.length <= 5) {
      return (totalPHUsers * (0.1 + random.nextDouble() * 0.2)).toInt();
    } else if (pCode.length <= 7) {
      return (totalPHUsers * (0.02 + random.nextDouble() * 0.05)).toInt();
    } else if (pCode.length <= 10) {
      return (totalPHUsers * (0.005 + random.nextDouble() * 0.01)).toInt();
    } else {
      return (random.nextInt(50));
    }
  }
}