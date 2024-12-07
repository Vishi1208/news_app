import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:news_app/providers/news_provider.dart';
import 'package:news_app/screens/article_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String selectedCategory = 'general';

  void _fetchCategoryNews(BuildContext context, String category) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    newsProvider.fetchNewsByCategory(category);
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Categories',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: isDarkMode ? Colors.black87 : Colors.blueAccent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.white,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
              const Color(0xFF1E1E2C),
              const Color(0xFF23232E),
            ]
                : [
              const Color(0xFFE3F2FD),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Horizontal category list
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildCategoryChip('General', Icons.language, isDarkMode),
                    _buildCategoryChip('Technology', Icons.computer, isDarkMode),
                    _buildCategoryChip('Sports', Icons.sports_soccer, isDarkMode),
                    _buildCategoryChip('Health', Icons.health_and_safety, isDarkMode),
                    _buildCategoryChip('Business', Icons.business_center, isDarkMode),
                    _buildCategoryChip('Entertainment', Icons.movie, isDarkMode),
                  ],
                ),
              ),
            ),
            newsProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                itemCount: newsProvider.articles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
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
                                fontSize: 20,
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
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, IconData icon, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ChoiceChip(
        label: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
            const SizedBox(width: 4),
            Text(
              category,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        selected: selectedCategory == category.toLowerCase(),
        selectedColor: isDarkMode
            ? Colors.blueAccent.withOpacity(0.6)
            : Colors.blue.withOpacity(0.3),
        backgroundColor: isDarkMode
            ? Colors.grey.withOpacity(0.4)
            : Colors.grey.withOpacity(0.3),
        onSelected: (isSelected) {
          if (isSelected) {
            _fetchCategoryNews(context, category.toLowerCase());
          }
        },
      ),
    );
  }
}
