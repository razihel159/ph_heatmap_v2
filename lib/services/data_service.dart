import 'dart:math';

class DataService {
  static const int totalPHUsers = 50000;

  static int getUserCountForArea(String pCode) {
    if (pCode == '0' || pCode.isEmpty) return 0;

    final int seed = pCode.hashCode;
    final random = Random(seed);
    final double weight = random.nextDouble(); 

    if (pCode.length <= 6) {
      return (totalPHUsers * weight * 0.15).toInt();
    } else if (pCode.length <= 9) { 
      return (totalPHUsers * weight * 0.02).toInt();
    } else { 
      return (totalPHUsers * weight * 0.001).toInt();
    }
  }
}