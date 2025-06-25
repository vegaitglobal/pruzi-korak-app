import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrganizationRepositoryImpl implements OrganizationRepository {
  OrganizationRepositoryImpl(this._client);

  final SupabaseClient _client;

  static const _pruziKorakId =
      'd0b15828-1111-4dec-9db4-cd2129dbfc8f'; //HARDCODED ID PRUŽI KORAK

  @override
  Future<OrganizationData> fetchById(String organizationId) async {
    final json =
        await _client
            .from('organizations')
            .select('message, social_media(*)')
            .eq('id', organizationId)
            .single();

    return OrganizationData.fromJson(json);
  }

  @override
  Future<OrganizationData> fetchPruziKorak() async {
    final json = await _client.rpc('get_pruzi_korak_organization_with_socials');
    return OrganizationData.fromJson(json);
  }

  @override
  Future<OrganizationData> fetchBySession() async {
    final json = await _client.rpc('get_my_organization_with_socials');
    return OrganizationData.fromJson(json);
  }
}
