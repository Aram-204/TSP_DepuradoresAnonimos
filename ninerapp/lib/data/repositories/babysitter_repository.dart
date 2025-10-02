import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ninerapp/domain/repositories/ibabysitter_repository.dart';
import 'package:ninerapp/domain/entities/babysitter.dart';

// Implementación técnica del repositorio de Child
class BabysitterRepository implements IBabysitterRepository {
  final SupabaseClient _supabase;

  BabysitterRepository({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<List<Babysitter>> getBabysitters(int minimumStars, int minDistanceMts, int maxDistanceMts, int minExpYears, int maxExpYears, int minPricePerHour, int maxPricePerHour, bool hasPhisicalDisabilityExp, bool hasVisualDisabilityExp, bool hasHearingDisabilityExp) async {
    try {
      var response = await _supabase
        .from('babysitter')
        .select('*')
        .order('name', ascending: true);


      final List<Babysitter> babysitters = (response as List)
        .map((babysitter) {
          return Babysitter.fromMap({
            ...babysitter,
          });
        }).toList();

      return babysitters;
    } on PostgrestException catch (e) {
      throw Exception('Error al obtener niñeros: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al obtener las niñeros: $e');
    }
  }
}