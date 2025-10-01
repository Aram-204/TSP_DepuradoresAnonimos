import 'package:ninerapp/domain/entities/child.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:ninerapp/domain/repositories/ichild_repository.dart';

// Implementación técnica del repositorio de Child
class ChildRepository implements IChildRepository {
  final SupabaseClient _supabase;

  ChildRepository({required SupabaseClient supabase}) : _supabase = supabase;

  @override
  Future<void> addChild(Child child) {
    try {
      return _supabase.from('child').insert(child.toMap());
    } on PostgrestException catch (e) {
      throw Exception('Error al agregar hijo: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al agregar hijo: $e');
    }
  }

  @override
  Future<void> deleteChild(int id) {
    try {
      return _supabase.from('child').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw Exception('Error al eliminar hijo: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al eliminar hijo: $e');
    }
  }

  @override
  Future<List<Child>> getChildrenByOrder(String order) async {
    try {
      var response = await _supabase
        .from('child')
        .select('*')
        .order('name', ascending: !order.contains('(Z-A)'));

      if (order.contains('Ordenar por edad')) {
        response = await _supabase
          .from('child')
          .select('*')
          .order('birthdate', ascending: order.contains('(mayor-menor)'));
      }

      final List<Child> children = (response as List)
        .map((child) {
          return Child.fromMap({
            ...child,
          });
        }).toList();

      return children;
    } on PostgrestException catch (e) {
      throw Exception('Error al obtener hijos: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al obtener las hijos: $e');
    }
  }

  @override
  Future<void> updateChild(Child child) {
    throw UnimplementedError();
  }
}