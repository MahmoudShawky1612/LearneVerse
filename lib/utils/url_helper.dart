class UrlHelper {
  static const String CLOUDFLARED_URL =
      "https://bb37-217-55-63-153.ngrok-free.app";
  static const String LOCAL_URL = "http://localhost:5500";

  static String transformUrl(String url) {
    // Handle empty or null URLs
    if (url.isEmpty || url.trim().isEmpty) {
      return ''; // Return empty string for empty URLs
    }
    
    // Replace localhost URLs with ngrok URL
    if (url.contains('localhost:5500') || url.contains('localhost')) {
      return url.replaceAll(RegExp(r'http://localhost:?\d*'), CLOUDFLARED_URL);
    }
    return url;
  }

  // Alternative method if you need more control
  static String buildImageUrl(String imagePath) {
    // Remove any leading slash and build complete URL
    final cleanPath =
        imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    return '$CLOUDFLARED_URL/$cleanPath';
  }
}
