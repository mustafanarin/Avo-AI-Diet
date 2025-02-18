import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:flutter/material.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Besin Ara'),
      ),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: ProjectColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: ProjectColors.forestGreen.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: ProjectColors.forestGreen,
                ),
                iconColor: ProjectColors.forestGreen,
                hintText: 'Besin adı girin...',
                filled: true,
                fillColor: ProjectColors.white,
              ),
            ),
          ),
          Container(
            height: 200,
            color: Colors.amber,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            color: Colors.amber,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            color: Colors.amber,
          ),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: 200,
            color: Colors.amber,
          ),
        ],
      ),
    );
  }
}
