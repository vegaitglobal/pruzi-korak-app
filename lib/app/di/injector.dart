import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_device_identifier/mobile_device_identifier.dart';
import 'package:pruzi_korak/core/events/login_notification_event.dart';
import 'package:pruzi_korak/core/session/session_stream.dart';
import 'package:pruzi_korak/core/supabase/tenant_supabase_client.dart';
import 'package:pruzi_korak/data/auth/auth_repository_impl.dart';
import 'package:pruzi_korak/data/home/home_repository.dart';
import 'package:pruzi_korak/data/home/home_repository_impl.dart';
import 'package:pruzi_korak/data/leaderboard/leaderboard_repository.dart';
import 'package:pruzi_korak/data/leaderboard/leaderboard_repository_impl.dart';
import 'package:pruzi_korak/data/local/local_storage.dart';
import 'package:pruzi_korak/data/local/local_storage_impl.dart';
import 'package:pruzi_korak/data/notification/local_notification_handler.dart';
import 'package:pruzi_korak/data/notification/local_notification_service.dart';
import 'package:pruzi_korak/data/notification/local_notification_service_impl.dart';
import 'package:pruzi_korak/data/permissions/permissions_service.dart';
import 'package:pruzi_korak/data/permissions/permissions_service_impl.dart';
import 'package:pruzi_korak/data/profile/profile_repository.dart';
import 'package:pruzi_korak/data/profile/profile_repository_impl.dart';
import 'package:pruzi_korak/domain/auth/auth_repository.dart';
import 'package:pruzi_korak/data/organization/organization_repository_impl.dart';
import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:pruzi_korak/data/user_content/user_content_repository.dart';
import 'package:pruzi_korak/data/user_content/user_content_repository_impl.dart';
import 'package:pruzi_korak/features/motivational_message/motivational_message_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'mapper_setup.dart';

GetIt getIt = GetIt.instance;

Future<void> configureDI() async {
  await _initSharedPref();
  await setupNotification();

  setupInitialLocator();
  setupJsonMappers();
  setRepositories();
}

void setupInitialLocator() {
  getIt.registerSingleton<SessionStream>(SessionStream());
  getIt.registerSingleton<SupabaseClient>(Supabase.instance.client);
  getIt.registerSingleton<LoginNotificationEvent>(LoginNotificationEvent());

  getIt.registerLazySingleton<OrganizationRepository>(
    () => OrganizationRepositoryImpl(getIt<SupabaseClient>()),
  );

  getIt.registerLazySingleton<MobileDeviceIdentifier>(
    () => MobileDeviceIdentifier(),
  );

  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<SupabaseClient>(),
      getIt<AppLocalStorage>(),
      getIt<OrganizationRepository>(),
      getIt<MobileDeviceIdentifier>(),
    ),
  );
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

void setRepositories() {
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<SupabaseClient>(), getIt<AppLocalStorage>()),
  );
  getIt.registerLazySingleton<LeaderboardRepository>(
    () => LeaderboardRepositoryImpl(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<UserContentRepository>(
    () => UserContentRepositoryImpl(getIt<SupabaseClient>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(getIt<SupabaseClient>()),
  );
  getIt.registerFactory<MotivationalMessageBloc>(
    () => MotivationalMessageBloc(getIt<UserContentRepository>()),
  );
}

Future<void> setupNotification() async {
  getIt.registerLazySingleton(() => FlutterLocalNotificationsPlugin());

  // Register permissions service
  getIt.registerLazySingleton<PermissionsService>(
    () => PermissionsServiceImpl(getIt<FlutterLocalNotificationsPlugin>()),
  );

  getIt.registerLazySingleton<LocalNotificationService>(
    () => LocalNotificationServiceImpl(getIt()),
  );

  getIt.registerLazySingleton<LocalNotificationHandler>(
    () => LocalNotificationHandler(
      getIt<LocalNotificationService>(),
      getIt<AuthRepository>(),
    ),
  );
}

Future<void> _initSharedPref() async {
  SharedPreferences sharedPref = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPref);

  getIt.registerLazySingleton<AppLocalStorage>(
    () => AppLocalStorageImpl(getIt<SharedPreferences>()),
  );
}