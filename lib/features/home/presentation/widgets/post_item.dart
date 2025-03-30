import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PostItem extends StatefulWidget {
  final Map<String, dynamic> post;

  const PostItem({Key? key, required this.post}) : super(key: key);

  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  bool isExpanded = false;
  bool isUpVoted = false;
  bool isDownVoted = false;

  @override
  Widget build(BuildContext context) {
    final post = widget.post;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.purple.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(post['avatar']),
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post['author'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      'Posted ${post['time']} hours ago',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    Icons.more_horiz,
                    color: Colors.grey[600],
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post['title'],
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Colors.black,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['description'],
                  maxLines: isExpanded ? null : 3,
                  overflow: isExpanded
                      ? TextOverflow.visible
                      : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (post['description'].length > 200)
                  GestureDetector(
                    onTap: () => setState(() => isExpanded = !isExpanded),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        isExpanded ? 'Show less' : 'Read more...',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isUpVoted) {
                            post['voteCount']--;
                            isUpVoted = false;
                          } else {
                            post['voteCount']++;
                            isUpVoted = true;
                            isDownVoted = false;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_circle_up_rounded,
                          size: 26,
                          color: isUpVoted
                              ? Colors.green[600]
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Center(
                        child: Text(
                          '${post['voteCount']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: post['voteCount'] > 0
                                ? Colors.green[700]
                                : post['voteCount'] < 0
                                    ? Colors.red[700]
                                    : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isDownVoted) {
                            post['voteCount']++;
                            isDownVoted = false;
                          } else {
                            post['voteCount']--;
                            isDownVoted = true;
                            isUpVoted = false;
                          }
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.all(8),
                        child: Icon(
                          Icons.arrow_circle_down_rounded,
                          size: 26,
                          color: isDownVoted
                              ? Colors.red[600]
                              : Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.comment,
                          size: 20,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${post['commentCount']}',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
