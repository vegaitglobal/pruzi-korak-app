import 'package:pruzi_korak/shared_ui/util/string_extensions.dart';
import 'package:url_launcher/url_launcher.dart';


Future<void> launchURL(String? url) async {
  if (url.isNotNullOrEmpty) {
    final Uri uri = Uri.parse(url!);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch $uri');
    }
  }
}
