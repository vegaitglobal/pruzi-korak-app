part of 'campaign_message_bloc.dart';

sealed class CampaignMessageState extends Equatable {
  const CampaignMessageState();

  @override
  List<Object> get props => [];
}

final class CampaignMessageInitial extends CampaignMessageState {
  const CampaignMessageInitial();
}

final class CampaignMessageLoading extends CampaignMessageState {
  const CampaignMessageLoading();
}

final class CampaignMessageLoaded extends CampaignMessageState {
  final CampaignMessage campaignMessage;

  const CampaignMessageLoaded({required this.campaignMessage});

  @override
  List<Object> get props => [campaignMessage];
}

final class CampaignMessageError extends CampaignMessageState {
  const CampaignMessageError();
}
