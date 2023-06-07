import 'package:flutter/material.dart';
import 'package:local_biz/config.dart';

import 'shop/shop_scroll_controller.dart';
import 'shop/shop_scroll_coordinator.dart';

class Comments extends StatefulWidget {
  final ShopScrollCoordinator shopCoordinator;

  const Comments({super.key, required this.shopCoordinator});

  @override
  _CommentsState createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  late ShopScrollCoordinator _shopCoordinator;
  late ShopScrollController _listScrollController;

  @override
  void initState() {
    _shopCoordinator = widget.shopCoordinator;
    _listScrollController = _shopCoordinator.newChildScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Comment> comments = [
      Comment(
        avatar: null,
        name: "张三",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
      Comment(
        avatar: null,
        name: "李四",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
      Comment(
        avatar: null,
        name: "王五",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
      Comment(
        avatar: null,
        name: "赵六",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
      Comment(
        avatar: null,
        name: "张三",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
      Comment(
        avatar: null,
        name: "李四",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
      Comment(
        avatar: null,
        name: "王五",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
      Comment(
        avatar: null,
        name: "赵六",
        content: "这个店铺真好",
        time: "2021-08-01",
        star: 5,
        images: [],
      ),
    ];
    return ListView.builder(
      padding: const EdgeInsets.all(0),
      physics: const ClampingScrollPhysics(),
      controller: _listScrollController,
      itemCount: comments.length,
      itemBuilder: (context, index) => _commentItem(comments[index]),
    );
  }

  Widget _commentItem(Comment comment) {
    var theme = Theme.of(context);
    var colorScheme = theme.colorScheme;
    var titleStyle = theme.textTheme.titleMedium!.copyWith(
      fontSize: 18,
      color: colorScheme.onSurface,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: comment.avatar != null
                        ? NetworkImage(comment.avatar!)
                        : const AssetImage(defaultUserImage) as ImageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(comment.name, style: titleStyle),
                        Text(comment.time),
                      ],
                    ),
                    Row(
                      children: [
                        const Text("评分："),
                        for (int i = 0; i < comment.star; i++)
                          Icon(Icons.star, color: colorScheme.primary),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    Text(comment.content),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _listScrollController?.dispose();
    //_listScrollController = null;
    super.dispose();
  }
}

class Comment {
  final String? avatar;
  final String name;
  final String content;
  final String time;
  final int star;
  final List<String> images;

  Comment({
    required this.avatar,
    required this.name,
    required this.content,
    required this.time,
    required this.star,
    required this.images,
  });
}
