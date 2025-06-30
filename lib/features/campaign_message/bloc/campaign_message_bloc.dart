import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pruzi_korak/domain/organization/OrganizationRepository.dart';
import 'package:pruzi_korak/domain/campaign/campaign_message.dart';
part 'campaign_message_event.dart';
part 'campaign_message_state.dart';

class CampaignMessageBloc extends Bloc<CampaignMessageEvent, CampaignMessageState> {
  CampaignMessageBloc(this._repo) : super(CampaignMessageInitial()) {
    on<CampaignMessageLoad>(_onLoad);

    // Automatically load when bloc is created
    add(const CampaignMessageLoad());
  }

  final OrganizationRepository _repo;

  Future<void> _onLoad(
    CampaignMessageLoad event,
    Emitter<CampaignMessageState> emit,
  ) async {
    emit(CampaignMessageLoading());
    try {
      final data = await _repo.fetchBySession();

      final campaignMessage = CampaignMessage(
        id: 'session', // Using a placeholder ID
        message: data.description,
        logoUrl: data.logoUrl,
        heading: data.heading,
      );

      emit(CampaignMessageLoaded(campaignMessage: campaignMessage));
    } catch (e) {
      emit(CampaignMessageError());
    }
  }
}
