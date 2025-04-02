import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../models/user_comments_model.dart';

class CommentItem extends StatefulWidget {
  final UserComment comment;

  const CommentItem({Key? key, required this.comment}) : super(key: key);

  @override
  _CommentItemState createState() => _CommentItemState();
}

class _CommentItemState extends State<CommentItem> {
  bool isUpVoted = false;
  bool isDownVoted = false;
  bool isExpanded = false;
  bool showOptions = false;

  @override
  Widget build(BuildContext context) {
    final comment = widget.comment;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.8),
            Colors.grey.shade200.withOpacity(0.8)
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(4, 4),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(-4, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade300, Colors.purple.shade300],
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage(comment.avatar),
                    backgroundColor: Colors.white,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          comment.author ,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(width: 5,),
                        FaIcon(FontAwesomeIcons.solidCircle, size: 7,),
                        SizedBox(width: 5,),

                        Text(
                          comment.repliedTo,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${comment.time}h ago',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 10,
                      backgroundImage: AssetImage(comment.communityImage),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      comment.communityName,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        IconButton(
                          icon: Icon(
                            Icons.more_horiz,
                            color: Colors.grey.shade700,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() {
                              showOptions = !showOptions;
                            });
                          },
                        ),
                        if (showOptions)
                          Positioned(
                            right: 40,
                            top: -10,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        Colors.grey.shade300.withOpacity(0.5),
                                    blurRadius: 8,
                                    spreadRadius: 1,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Text(
                                      'Edit',
                                      style: TextStyle(
                                        color: Colors.blue.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        shadows: [
                                          Shadow(
                                            color: Colors.blue.shade200,
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                        shadows: [
                                          Shadow(
                                            color: Colors.red.shade200,
                                            offset: const Offset(0, 1),
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
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
              ],
            ),
            const SizedBox(height: 12),
            Text(
              comment.comment,
              style: TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.6,
                overflow:
                    isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              maxLines: isExpanded ? null : 2,
            ),
            if (comment.comment.length > 100)
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    isExpanded ? 'Show less' : 'Read more',
                    style: TextStyle(
                      color: Colors.blue.shade600,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isUpVoted) {
                            comment.voteCount--;
                            isUpVoted = false;
                          } else {
                            comment.voteCount++;
                            isUpVoted = true;
                            isDownVoted = false;
                          }
                        });
                      },
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isUpVoted ? 1.2 : 1.0,
                        child: Icon(
                          CupertinoIcons.arrow_up_circle_fill,
                          size: 24,
                          color: isUpVoted
                              ? Colors.green.shade600
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${comment.voteCount}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: comment.voteCount > 0
                            ? Colors.green.shade700
                            : comment.voteCount < 0
                                ? Colors.red.shade700
                                : Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isDownVoted) {
                            comment.voteCount++;
                            isDownVoted = false;
                          } else {
                            comment.voteCount--;
                            isDownVoted = true;
                            isUpVoted = false;
                          }
                        });
                      },
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 150),
                        scale: isDownVoted ? 1.2 : 1.0,
                        child: Icon(
                          CupertinoIcons.arrow_down_circle_fill,
                          size: 24,
                          color: isDownVoted
                              ? Colors.red.shade600
                              : Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.reply,
                        size: 16,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'Reply',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ],
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
