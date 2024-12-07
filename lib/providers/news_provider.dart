import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:news_app/models/article.dart';

class NewsProvider with ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _bookmarkedArticles = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Article> get articles => _articles;
  List<Article> get bookmarkedArticles => _bookmarkedArticles;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  //trending news
  Future<void> fetchTrendingNews() async {
    _setLoading(true);
    _clearError();

    _articles.clear();
    final url = Uri.parse('https://newsapi.org/v2/top-headlines?country=us&apiKey=e2a4eea31ae44bc79878fb7e0af0d557');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = (data['articles'] as List).map((json) => Article.fromJson(json)).toList();
      } else {
        _setError('Failed to load trending news: ${response.reasonPhrase}');
      }
    } catch (error) {
      _setError('Error fetching trending news: $error');
    }

    _setLoading(false);
  }

  //category
  Future<void> fetchNewsByCategory(String category) async {
    _setLoading(true);
    _clearError();

    _articles.clear();
    final String formattedCategory = category.toLowerCase();
    final url = Uri.parse(
        'https://newsapi.org/v2/top-headlines?country=us&category=$formattedCategory&apiKey=e2a4eea31ae44bc79878fb7e0af0d557');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = (data['articles'] as List).map((json) => Article.fromJson(json)).toList();
      } else {
        _setError('Failed to load category news: ${response.reasonPhrase}');
      }
    } catch (error) {
      _setError('Error fetching category news: $error');
    }

    _setLoading(false);
  }


  Future<void> fetchNewsByKeyword(String keyword) async {
    _setLoading(true);
    _clearError();

    _articles.clear();
    final url = Uri.parse(
        'https://newsapi.org/v2/everything?q=$keyword&apiKey=e2a4eea31ae44bc79878fb7e0af0d557');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _articles = (data['articles'] as List).map((json) => Article.fromJson(json)).toList();
      } else {
        _setError('Failed to load search results: ${response.reasonPhrase}');
      }
    } catch (error) {
      _setError('Error fetching search results: $error');
    }

    _setLoading(false);
  }


  void addBookmark(Article article) {
    if (!_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.add(article);
      notifyListeners();
    }
  }


  void removeBookmark(Article article) {
    _bookmarkedArticles.remove(article);
    notifyListeners();
  }


  bool isArticleBookmarked(Article article) {
    return _bookmarkedArticles.contains(article);
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }


  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
