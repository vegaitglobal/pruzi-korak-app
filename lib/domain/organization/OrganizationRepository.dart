/// Abstract repository -----------------------------------------------------

abstract class OrganizationRepository {
  /// Fetch organization by ID and return description + social links.
  Future<OrganizationData> fetchById(String organizationId);

  /// Convenience helper for the Pruži korak organization (fixed UUID)
  Future<OrganizationData> fetchPruziKorak();
}

/// Simple DTOs -------------------------------------------------------------

class SocialLink {
  SocialLink({required this.iconPath, required this.url});

  factory SocialLink.fromJson(Map<String, dynamic> json) => SocialLink(
    iconPath: _iconFromUrl(json['url'] as String),
    url: json['url'] as String,
  );

  final String iconPath;
  final String url;

  static String _iconFromUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('facebook')) return 'assets/icons/facebook.svg';
    if (lower.contains('instagram')) return 'assets/icons/instagram.svg';
    if (lower.contains('linkedin')) return 'assets/icons/linkedin.svg';
    if (lower.contains('twitter') || lower.contains('x.com')) {
      return 'assets/icons/twitter.svg';
    }
    if (lower.startsWith('mailto:')) return 'assets/icons/mail.svg';
    // fallback
    return 'assets/icons/link.svg';
  }

  /// Picks an icon based on the JSON field key (e.g. 'facebook_url').
  static String _iconFromKey(String key) {
    final lower = key.toLowerCase();
    if (lower.contains('facebook')) return 'assets/icons/facebook.svg';
    if (lower.contains('instagram')) return 'assets/icons/instagram.svg';
    if (lower.contains('linkedin')) return 'assets/icons/linkedin.svg';
    if (lower.contains('twitter')) return 'assets/icons/twitter.svg';
    if (lower.contains('email')) return 'assets/icons/email.svg';
    return 'assets/icons/link.svg';
  }
}

class OrganizationData {
  OrganizationData({required this.description, required this.socialLinks});

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    // -------------------------------------------------------------------
    // 1. Description (nazvan "message" na backendu)
    // -------------------------------------------------------------------
    final String description = json['message'] as String? ?? '';

    // -------------------------------------------------------------------
    // 2. Social media links – backend vraća listu (najčešće 1 map)
    //    sa ključevima facebook_url, instagram_url, linkedin_url ...
    // -------------------------------------------------------------------
    final List<SocialLink> links = [];

    if (json['social_media'] is List &&
        (json['social_media'] as List).isNotEmpty) {
      final Map<String, dynamic> sm =
          (json['social_media'] as List).first as Map<String, dynamic>;

      void maybeAdd(String key, String? url) {
        if (url == null || url.isEmpty) return;

        String effectiveUrl = url;

        // Ako je ovo mejl polje i nema već šemu, dodaj "mailto:"
        if (key.toLowerCase().contains('email') &&
            !effectiveUrl.startsWith('mailto:')) {
          effectiveUrl = 'mailto:$effectiveUrl';
        }

        links.add(
          SocialLink(
            iconPath: SocialLink._iconFromKey(key),
            url: effectiveUrl,
          ),
        );
      }

      maybeAdd('facebook_url', sm['facebook_url'] as String?);
      maybeAdd('instagram_url', sm['instagram_url'] as String?);
      maybeAdd('linkedin_url', sm['linkedin_url'] as String?);
      maybeAdd('twitter_url', sm['twitter_url'] as String?);
      maybeAdd('email', sm['email'] as String?);
    }

    return OrganizationData(description: description, socialLinks: links);
  }

  final String description;
  final List<SocialLink> socialLinks;
}
