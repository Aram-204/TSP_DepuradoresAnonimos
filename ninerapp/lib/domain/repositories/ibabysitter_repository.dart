
import 'package:ninerapp/domain/entities/babysitter.dart';

abstract class IBabysitterRepository {
  Future<List<Babysitter>> getBabysitters(int minimumStars, int minDistanceMts, int maxDistanceMts, int minExpYears, int maxExpYears, int minPricePerHour, int maxPricePerHour, bool hasPhisicalDisabilityExp, bool hasVisualDisabilityExp, bool hasHearingDisabilityExp);
}