import 'package:flutter/material.dart';

class ArticleDetailsScreen extends StatefulWidget {
  static const String articleId = "articleId";

  const ArticleDetailsScreen({super.key});

  @override
  State<ArticleDetailsScreen> createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState extends State<ArticleDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: const Text(
        "Hello details",
        style: TextStyle(color: Colors.black, fontSize: 18),
      ),
    );
  }
}
