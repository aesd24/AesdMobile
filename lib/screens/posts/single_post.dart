import 'package:aesd_app/models/post_model.dart';
import 'package:flutter/material.dart';

class SinglePost extends StatefulWidget {
  SinglePost({super.key, required this.post});

  PostModel post;

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const CircleAvatar(),
                    const SizedBox(width: 10),
                    Text(widget.post.author,
                        style: Theme.of(context).textTheme.titleMedium)
                  ],
                ),
                Text(
                  widget.post.date,
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .copyWith(color: Colors.grey),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                widget.post.content,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 20),
              child: Row(
                children: [
                  Row(
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        icon: Icon(widget.post.liked
                            ? Icons.favorite
                            : Icons.favorite_border),
                        label: Text(widget.post.likes.toString()),
                        style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.all(Colors.red),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.red.shade50)),
                      ),
                      const SizedBox(width: 15),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.message),
                        label: Text(widget.post.comments.length.toString()),
                        style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.all(Colors.blue),
                            backgroundColor:
                                WidgetStateProperty.all(Colors.blue.shade50)),
                      )
                    ],
                  )
                ],
              ),
            )
          ])),
    );
  }
}
