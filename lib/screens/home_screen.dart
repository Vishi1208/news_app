import 'package:flutter/material.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/providers/theme_provider.dart';
import 'package:news_app/screens/search_screen.dart';
import 'package:news_app/screens/bookmark_screen.dart';
import 'package:news_app/screens/category_screen.dart';
import 'package:provider/provider.dart';
import 'article_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).fetchTrendingNews();
    });
  }

  Future<void> _refreshNews() async {
    await Provider.of<NewsProvider>(context, listen: false).fetchTrendingNews();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Trending News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? const Color(0xFF212121) : const Color(0xFF1976D2),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              isDarkMode ? Icons.wb_sunny : Icons.nightlight_round,
              color: isDarkMode ? Colors.yellow : Colors.white,
            ),
            onPressed: () {
              themeProvider.toggleTheme();
            },
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookmarkScreen()),
              );
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
                ? [
              const Color(0xFF2B2B2B),
              const Color(0xFF424242),
            ]
                : [
              const Color(0xFFE3F2FD),
              Colors.white,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _refreshNews,
          child: newsProvider.isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : ListView.builder(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            itemCount: newsProvider.articles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Card(
                  color: isDarkMode ? Colors.black54 : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black.withOpacity(0.4),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (newsProvider.articles[index].urlToImage.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              newsProvider.articles[index].urlToImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        const SizedBox(height: 16),
                        Text(
                          newsProvider.articles[index].title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          newsProvider.articles[index].description.isNotEmpty
                              ? newsProvider.articles[index].description
                              : 'No description available',
                          style: TextStyle(
                            fontSize: 16,
                            color: isDarkMode ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              // Navigate to article detail
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ArticleDetailScreen(
                                    article: newsProvider.articles[index],
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.open_in_new, size: 16),
                            label: const Text('Read More'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDarkMode
                                  ? const Color(0xFF64B5F6).withOpacity(0.8)
                                  : const Color(0xFF1976D2).withOpacity(0.9),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDarkMode
            ? const Color(0xFF64B5F6).withOpacity(0.85)
            : const Color(0xFF1976D2).withOpacity(0.9),
        icon: const Icon(Icons.category, color: Colors.white),
        label: const Text('Categories', style: TextStyle(color: Colors.white)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CategoryScreen()),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
