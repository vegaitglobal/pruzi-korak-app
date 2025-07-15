import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:pruzi_korak/domain/organization/organization_model.dart';
part 'about_pruzi_korak_event.dart';
part 'about_pruzi_korak_state.dart';

class AboutPruziKorakBloc
    extends Bloc<AboutPruziKorakEvent, AboutPruziKorakState> {
  AboutPruziKorakBloc(this._repo) : super(AboutPruziKorakInitial()) {
    on<AboutPruziKorakLoad>(_onLoad);

    // Automatically load when bloc is created
    add(const AboutPruziKorakLoad());
  }

  final OrganizationRepository _repo;

  Future<void> _onLoad(
    AboutPruziKorakLoad event,
    Emitter<AboutPruziKorakState> emit,
  ) async {
    emit(AboutPruziKorakLoading());
    try {
      final data = await _repo.fetchPruziKorak();

      final organization = OrganizationModel(
        id: 'd0b15828-1111-4dec-9db4-cd2129dbfc8f',
        description: data.description,
        socialLinks:
            data.socialLinks
                .map((s) => SocialLinkModel(iconPath: s.iconPath, url: s.url))
                .toList(),
        logoUrl: data.logoUrl,
        heading: data.heading,
        website_url1: data.website_url1,
        website_url2: data.website_url2,
      );

      emit(AboutPruziKorakLoaded(organization: organization));
    } catch (e) {
      emit(AboutPruziKorakError());
    }
  }
}
