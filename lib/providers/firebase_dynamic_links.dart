import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

class FirebaseDynamicLinkService {
  static Future<String> createdynamiclink(bool short, String keyString) async {
    String linkMessage;

    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://deaksapp.page.link',
        link: Uri.parse('https://deaksapp.page.link/jobs/${keyString}'),
        androidParameters: AndroidParameters(
          packageName: 'com.deaksapplication.deaks_applications',
          minimumVersion: 10,
        ),
        iosParameters: IOSParameters(
            bundleId: "com.deaksApplication.deaksApplication",
            minimumVersion: "11",
            appStoreId: "1635950859"));

    Uri url;
    if (true) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    linkMessage = url.toString();
    return linkMessage;
  }
}
