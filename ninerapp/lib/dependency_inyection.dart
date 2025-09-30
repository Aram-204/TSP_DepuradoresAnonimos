import 'package:get_it/get_it.dart';
import 'package:ninerapp/data/repositories/child_repository.dart';
import 'package:ninerapp/domain/repositories/ichild_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // Se llama al supabase cliente
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);

  // Se añaden los repositorios
  getIt.registerSingleton<IChildRepository>(ChildRepository(supabase: getIt<SupabaseClient>()));
}