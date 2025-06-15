class OrganizationModel {
  final String id;
  final String description;
  final List<SocialLinkModel> socialLinks;

  const OrganizationModel({
    required this.id,
    required this.description,
    required this.socialLinks,
  });

  @override
  String toString() {
    return 'OrganizationModel(id: $id, description: $description, socialLinks: $socialLinks)';
  }
}

class SocialLinkModel {
  final String iconPath;
  final String url;

  const SocialLinkModel({
    required this.iconPath,
    required this.url,
  });

  @override
  String toString() {
    return 'SocialLinkModel(iconPath: $iconPath, url: $url)';
  }
}
