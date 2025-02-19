import 'dart:convert';

import 'package:avo_ai_diet/feature/search/model/food_model.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/extensions/text_theme_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _controller = TextEditingController();
  List<FoodModel> _foods = [];
  List<FoodModel> _filteredFoods = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  Future<void> _loadFoods() async {
    try {
      final response = await rootBundle.loadString('assets/json/foods.json');
      final data = jsonDecode(response);
      setState(() {
        _foods = (data['foods'] as List).map((item) => FoodModel.fromJson(item as Map<String, dynamic>)).toList();
        _filteredFoods = _foods;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100,
            floating: true, // for scroll
            pinned: true, // for title
            elevation: 0,
            backgroundColor: ProjectColors.backgroundCream,
            centerTitle: false,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: const EdgeInsets.only(left: 16),
              title: Text(
                'Besin Ara',
                style: context.textTheme().titleLarge,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
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
          ),
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(
                  color: ProjectColors.forestGreen,
                ),
              ),
            )
          else if (_filteredFoods.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.search_off_rounded),
                    SizedBox(
                      height: 16,
                    ),
                    Text('Sonuç bulunamadı'),
                  ],
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final food = _filteredFoods[index];
                  return _FoodCard(food: food);
                },
                childCount: _filteredFoods.length,
              ),
            ),
        ],
      ),
    );
  }
}

class _FoodCard extends StatelessWidget {
  const _FoodCard({
    required this.food,
    super.key,
  });

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Card(
        child: Column(
          children: [
             ListTile(
              leading: Icon(Icons.free_breakfast),
              title: Text(food.name),
              subtitle: Text("100g"),
              trailing: Container(
                color: ProjectColors.grey.withOpacity(0.2),
                child: Text("${food.calorie}",style: TextStyle(fontSize: 17),)),
            ),
            Row(
              children: [
                _NutritionInfoBox(food: food),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NutritionInfoBox extends StatelessWidget {
  const _NutritionInfoBox({
    super.key,
    required this.food,
  });

  final FoodModel food;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: ProjectColors.forestGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.food_bank),
          const SizedBox(
            width: 4,
          ),
          Text('${food.protein}g'),
        ],
      ),
    );
  }
}
