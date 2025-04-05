import 'dart:math';

import 'author_model.dart';
import 'community_model.dart';


class Post {
  final String title;
  final String description;
  int voteCount;
  final int upvote;
  final int downVote;
  final String author;
  final String avatar;
  final int time;
  final int commentCount;
  final String communityName;
  final String communityImage;
  final List<String> tags;

  Post({
    required this.title,
    required this.description,
    required this.voteCount,
    required this.upvote,
    required this.downVote,
    required this.author,
    required this.avatar,
    required this.time,
    required this.commentCount,
    required this.communityName,
    required this.communityImage,
    required this.tags,
  });

  static List<Post> generateDummyPosts(int count) {
    final authors = Author.generateDummyAuthors();
    final communities = Community.generateDummyCommunities();
    final random = Random();

    // Define some common post tags across programming topics
    final Map<String, List<String>> topicTags = {
      'Web Development': ['JavaScript', 'React', 'Angular', 'Vue', 'HTML', 'CSS', 'Frontend', 'Web Development', 'Responsive Design'],
      'Mobile Apps': ['Flutter', 'React Native', 'Swift', 'Kotlin', 'Android', 'iOS', 'Mobile Apps', 'UI/UX', 'App Development'],
      'Backend': ['Node.js', 'Express', 'Spring', 'Django', 'API', 'REST', 'GraphQL', 'Backend', 'Server', 'Microservices'],
      'Data Science': ['Python', 'Machine Learning', 'Data Science', 'Data Analysis', 'Statistical Analysis', 'Pandas', 'NumPy', 'TensorFlow'],
      'DevOps': ['Docker', 'Kubernetes', 'CI/CD', 'AWS', 'Azure', 'Cloud Computing', 'DevOps', 'Infrastructure', 'Deployment'],
      'Security': ['Cybersecurity', 'Blockchain', 'Cryptography', 'Ethical Hacking', 'Network Security', 'Security', 'Privacy'],
      'General': ['Programming', 'Algorithms', 'System Design', 'Best Practices', 'Performance', 'Code Review', 'Tutorial', 'Beginner', 'Advanced']
    };
    
    return List.generate(count, (index) {
      final author = authors[index % authors.length];
      final community = communities[index % communities.length];

      // Get primary topic for this post based on index
      final String primaryTopic = topicTags.keys.elementAt(index % topicTags.length);
      
      // Generate relevant tags for the post
      List<String> postTags = [];
      
      // Add 1-2 tags from the primary topic
      final primaryTagCount = random.nextInt(2) + 1;
      for (int i = 0; i < primaryTagCount; i++) {
        final tagList = topicTags[primaryTopic]!;
        final tag = tagList[random.nextInt(tagList.length)];
        if (!postTags.contains(tag)) {
          postTags.add(tag);
        }
      }
      
      // 50% chance to include a tag from the community
      if (random.nextBool() && community.tags.isNotEmpty) {
        final communityTag = community.tags[random.nextInt(community.tags.length)];
        if (!postTags.contains(communityTag)) {
          postTags.add(communityTag);
        }
      }
      
      // 50% chance to include a tag from the author's interests
      if (random.nextBool() && author.interests.isNotEmpty) {
        final interestTag = author.interests[random.nextInt(author.interests.length)];
        if (!postTags.contains(interestTag)) {
          postTags.add(interestTag);
        }
      }
      
      // Ensure each post has at least 2 tags
      if (postTags.length < 2) {
        final generalTags = topicTags['General']!;
        postTags.add(generalTags[random.nextInt(generalTags.length)]);
      }

      // Generate post title based on tags
      String postTitle = "Post about ";
      if (postTags.isNotEmpty) {
        postTitle += postTags[random.nextInt(postTags.length)];
      } else {
        postTitle += "programming";
      }
      postTitle += " ${index + 1}";

      // Generate post description based on tags
      String postDescription = "This is a detailed post about ";
      if (postTags.isNotEmpty) {
        postDescription += postTags.join(" and ");
      } else {
        postDescription += "programming concepts";
      }
      postDescription += ". It covers important topics that developers should know about...";

      return Post(
        title: postTitle,
        description: postDescription,
        voteCount: _calculateVoteCount(index),
        upvote: _calculateVoteCount(index),
        downVote: (index + 1) * 3 - 4,
        author: author.name,
        avatar: author.avatar,
        time: (index + 1) * 2 - 1,
        commentCount: Random().nextInt(50),
        communityImage: community.image,
        communityName: community.name,
        tags: postTags,
      );
    });
  }

  static int _calculateVoteCount(int index) => index * 3 - 4;
}