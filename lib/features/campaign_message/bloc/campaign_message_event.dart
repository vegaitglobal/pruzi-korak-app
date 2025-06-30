part of 'campaign_message_bloc.dart';

abstract class CampaignMessageEvent extends Equatable {
  const CampaignMessageEvent();

  @override
  List<Object> get props => [];
}

class CampaignMessageLoad extends CampaignMessageEvent {
  const CampaignMessageLoad();
}
