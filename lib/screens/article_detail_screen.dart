import 'package:flutter/material.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:provider/provider.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    bool isBookmarked = newsProvider.isArticleBookmarked(article);
    final theme = Theme.of(context);
    bool isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.4),
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_outline,
              color: Colors.yellow,
            ),
            onPressed: () {
              if (isBookmarked) {
                newsProvider.removeBookmark(article);
              } else {
                newsProvider.addBookmark(article);
              }
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [const Color(0xFF1E1E2C), const Color(0xFF23232E)]
                : [const Color(0xFFF0F0F0), const Color(0xFFE8E8E8)],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          children: [
            if (article.urlToImage.isNotEmpty)
              Hero(
                tag: article.urlToImage,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  child: Image.network(
                    article.urlToImage,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 250,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              article.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Published on: ${article.publishedAt.split('T')[0]}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: isDarkMode ? Colors.white54 : Colors.black54,
              ),
            ),
            const SizedBox(height: 16),
            if (article.description.isNotEmpty)
              Text(
                article.description,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.5,
                  color: isDarkMode ? Colors.white70 : Colors.black87,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
