class OrganizationModel {
  final String id;
  final String description;
  final List<SocialLinkModel> socialLinks;
  final String logoUrl;
  final String heading;
  final String website_url1;
  final String website_url2;

  const OrganizationModel({
    required this.id,
    required this.description,
    required this.socialLinks,
    required this.logoUrl,
    required this.heading,
    this.website_url1 = '',
    this.website_url2 = '',
  });

  @override
  String toString() {
    return 'OrganizationModel(id: $id, description: $description, socialLinks: $socialLinks, logoUrl: $logoUrl, heading: $heading, website_url1: $website_url1, website_url2: $website_url2)';
  }
}

class SocialLinkModel {
  final String iconPath;
  final String url;

  const SocialLinkModel({required this.iconPath, required this.url});

  @override
  String toString() {
    return 'SocialLinkModel(iconPath: $iconPath, url: $url)';
  }
}
