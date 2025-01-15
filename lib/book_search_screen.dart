import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'search_books.dart';

class BookSearchScreen extends StatefulWidget {
  @override
  _BookSearchScreenState createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _books = [];
  bool _isLoading = false;

  // Search books when the user submits the query
  Future<void> _searchBooks(String query) async {
    if (query.isEmpty) {
      setState(() {
        _books = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final url = Uri.parse(
          'http://localhost:8080/mobile_project_php/search_books.php?query=$query');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode response and handle empty results
        final List<dynamic> results = json.decode(response.body);
        setState(() {
          _books = results;
        });
      } else {
        setState(() {
          _books = [];
        });
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _books = [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Search'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Author or Subject',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    _searchBooks(_searchController.text.trim());
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : Expanded(
                    child: _books.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            itemCount: _books.length,
                            itemBuilder: (context, index) {
                              final book = _books[index];
                              return ListTile(
                                title: Text(book['title'] ?? 'Unknown Title'),
                                subtitle: Text(
                                  'Author: ${book['author'] ?? 'Unknown Author'} - '
                                  'Subject: ${book['subject'] ?? 'Unknown Subject'}',
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
}
