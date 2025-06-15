import 'package:get_it/get_it.dart';
import 'package:pruzi_korak/core/constants/app_constants.dart';
import 'package:pruzi_korak/core/session/session_stream.dart';
import 'package:pruzi_korak/core/supabase/tenant_supabase_client.dart';
import 'package:pruzi_korak/data/auth/AuthRepositoryImpl.dart';
import 'package:pruzi_korak/domain/auth/AuthRepository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mapper_setup.dart';

GetIt getIt = GetIt.instance;

Future<void> configureDI() async {
  setupInitialLocator();
  setupJsonMappers();
}

void setupInitialLocator() {
  getIt.registerSingleton<SessionStream>(SessionStream());
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(getIt<SupabaseClient>()),);
}

Future<void> setupTenantScopedServices(String tenantId) async {
  final supabaseService = TenantSupabaseClient(
    client: getIt<SupabaseClient>(),
    tenantId: tenantId,
  );

  getIt.registerSingleton<TenantSupabaseClient>(supabaseService);
}

void resetTenantScopedServices() {
  if (getIt.isRegistered<TenantSupabaseClient>()) {
    getIt.unregister<TenantSupabaseClient>();
  }
}
