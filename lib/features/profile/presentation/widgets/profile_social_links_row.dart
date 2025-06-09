import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutterwidgets/features/profile/data/models/user_profile_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'profile_social_button.dart';

class ProfileSocialLinksRow extends StatelessWidget {
  final UserProfile userInfo;
  const ProfileSocialLinksRow({super.key, required this.userInfo});

  void _launchURL(BuildContext context, String url) async {
    String normalizedUrl = url;
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      normalizedUrl = 'https://$url';
    }

    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid URL format')),
      );
      return;
    }

    try {
      if (await canLaunchUrl(uri)) {
        final success = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the link')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No browser available to open the link')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening link: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final links = [
      {'url': userInfo.twitter, 'icon': FontAwesomeIcons.twitter},
      {'url': userInfo.facebook, 'icon': FontAwesomeIcons.facebook},
      {'url': userInfo.instagram, 'icon': FontAwesomeIcons.instagram},
      {'url': userInfo.linkedin, 'icon': FontAwesomeIcons.linkedinIn},
      {'url': userInfo.youtube, 'icon': FontAwesomeIcons.youtube},
    ];
    final validLinks = links.where((link) {
      final url = link['url'] as String?;
      return url != null && url.trim().isNotEmpty;
    }).toList();

    if (validLinks.isEmpty) {
      return const SizedBox();
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: validLinks.map((link) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: ProfileSocialButton(
              icon: link['icon'] as IconData,
              onPressed: () => _launchURL(context, link['url'] as String),
            ),
          );
        }).toList(),
      ),
    );
  }
}