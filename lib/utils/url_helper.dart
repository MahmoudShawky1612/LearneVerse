class UrlHelper {
  static const String NGROK_URL = "https://0644-197-120-117-13.ngrok-free.app";
  static const String LOCAL_URL = "http://localhost:5500";

  static String transformUrl(String url) {
    // Replace localhost URLs with ngrok URL
    if (url.contains('localhost:5500') || url.contains('localhost')) {
      return url.replaceAll(RegExp(r'http://localhost:?\d*'), NGROK_URL);
    }
    return url;
  }

  // Alternative method if you need more control
  static String buildImageUrl(String imagePath) {
    // Remove any leading slash and build complete URL
    final cleanPath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$NGROK_URL/$cleanPath';
  }
}