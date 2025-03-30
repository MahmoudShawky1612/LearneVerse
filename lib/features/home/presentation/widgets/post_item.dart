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

    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue[200]!, width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(post['avatar']),
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
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Posted ${post['time']} hours ago',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post['title'],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post['description'],
                  maxLines: isExpanded ? null : 3,
                  overflow:
                      isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                    height: 1.4,
                  ),
                ),
                if (post['description'].length > 200)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        isExpanded ? 'Show less' : 'Read more...',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
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
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_circle_up,
                            color: isUpVoted ? Colors.green : Colors.grey[600],
                          ),
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
                            color: post['voteCount'] > 0
                                ? Colors.green[700]
                                : post['voteCount'] < 0
                                    ? Colors.red[700]
                                    : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.arrow_circle_down,
                            color: isDownVoted ? Colors.red : Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const FaIcon(
                            FontAwesomeIcons.comments,
                            size: 20,
                          ),
                          onPressed: () {},
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${post['commentCount']}',
                          style: TextStyle(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w600,
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
