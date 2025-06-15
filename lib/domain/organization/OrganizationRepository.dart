/// Abstract repository -----------------------------------------------------

abstract class OrganizationRepository {
  /// Fetch organization by ID and return description + social links.
  Future<OrganizationData> fetchById(String organizationId);

  /// Convenience helper for the Pruži korak organization (fixed UUID)
  Future<OrganizationData> fetchPruziKorak();

  /// Fetch organization for the current user session
  Future<OrganizationData> fetchBySession();
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
    return '';
  }
}

class OrganizationData {
  OrganizationData({
    required this.description,
    required this.socialLinks,
    required this.logoUrl,
    required this.heading,
    this.website_url1 = '',
    this.website_url2 = '',
  });

  factory OrganizationData.fromJson(Map<String, dynamic> json) {
    // -------------------------------------------------------------------
    // 1. Description (nazvan "message" na backendu)
    // -------------------------------------------------------------------
    final String description = json['message'] as String? ?? '';

    // -------------------------------------------------------------------
    // 2. Website URL, Logo URL, and Heading
    // -------------------------------------------------------------------

    final String logoUrl = json['media_url'] as String? ?? '';
    final String heading = json['name'] as String? ?? 'Poruka kompanije';

    // -------------------------------------------------------------------
    // 3. Social media links – backend vraća listu (najčešće 1 map)
    //    sa ključevima facebook_url, instagram_url, linkedin_url ...
    // -------------------------------------------------------------------
    final List<SocialLink> links = [];

    final dynamic smSource = json['social_media'];
    Map<String, dynamic>? sm;
    if (smSource is List && smSource.isNotEmpty) {
      sm = smSource.first as Map<String, dynamic>;
    } else if (smSource is Map<String, dynamic>) {
      sm = smSource;
    }

    String website_url1 = '';
    String website_url2 = '';

    if (sm != null) {
      website_url1 = sm['website_url1'] as String? ?? '';
      website_url2 = sm['website_url2'] as String? ?? '';
      void maybeAdd(String key, String? url) {
        if (url == null || url.isEmpty) return;

        String effectiveUrl = url;

        // Ako je ovo mejl polje i nema već šemu, dodaj "mailto:"
        if (key.toLowerCase().contains('email') &&
            !effectiveUrl.startsWith('mailto:')) {
          effectiveUrl = 'mailto:$effectiveUrl';
        }

        links.add(
          SocialLink(iconPath: SocialLink._iconFromKey(key), url: effectiveUrl),
        );
      }

      maybeAdd('facebook_url', sm['facebook_url'] as String?);
      maybeAdd('instagram_url', sm['instagram_url'] as String?);
      maybeAdd('linkedin_url', sm['linkedin_url'] as String?);
      maybeAdd('twitter_url', sm['twitter_url'] as String?);
      //maybeAdd('website_url1', sm['website_url1'] as String?);
      //maybeAdd('website_url2', sm['website_url2'] as String?);
      maybeAdd('email', sm['email'] as String?);
    }

    return OrganizationData(
      description: description,
      socialLinks: links,
      logoUrl: logoUrl,
      heading: heading,
      website_url1: website_url1,
      website_url2: website_url2,
    );
  }

  final String description;
  final List<SocialLink> socialLinks;
  final String logoUrl;
  final String heading;
  final String website_url1;
  final String website_url2;
}
