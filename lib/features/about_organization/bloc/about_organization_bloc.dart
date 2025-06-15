import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:pruzi_korak/domain/organization/organization_model.dart';
part 'about_organization_event.dart';
part 'about_organization_state.dart';

class AboutOrganizationBloc extends Bloc<AboutOrganizationEvent, AboutOrganizationState> {
  AboutOrganizationBloc(this._repo) : super(AboutOrganizationInitial()) {
    on<AboutOrganizationLoad>(_onLoad);

    // Automatically load when bloc is created
    add(const AboutOrganizationLoad());
  }

  final OrganizationRepository _repo;

  Future<void> _onLoad(
    AboutOrganizationLoad event,
    Emitter<AboutOrganizationState> emit,
  ) async {
    emit(AboutOrganizationLoading());
    try {
      final data = await _repo.fetchBySession();

      final organization = OrganizationModel(
        id: 'session', // Using a placeholder ID since we don't have it from the session
        description: data.description,
        socialLinks: data.socialLinks
            .map(
              (s) => SocialLinkModel(iconPath: s.iconPath, url: s.url),
            )
            .toList(),
        logoUrl: data.logoUrl,
        heading: data.heading,
        website_url1: data.website_url1,
        website_url2: data.website_url2,
      );

      emit(AboutOrganizationLoaded(organization: organization));
    } catch (e) {
      emit(AboutOrganizationError());
    }
  }
}
