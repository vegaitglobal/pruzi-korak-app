class CampaignMessage {
  final String id;
  final String message;
  final String logoUrl;
  final String heading;

  const CampaignMessage({
    required this.id,
    required this.message,
    required this.logoUrl,
    required this.heading,
  });

  @override
  String toString() {
    return 'CampaignMessage(id: $id, message: $message, logoUrl: $logoUrl, heading: $heading)';
  }
}
