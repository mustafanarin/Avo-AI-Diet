import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FavoriteView extends StatefulWidget {
  const FavoriteView({super.key});

  @override
  State<FavoriteView> createState() => _FavoriteViewState();
}

class _FavoriteViewState extends State<FavoriteView> {
  final List<String> _favoriteDiets = [
    'merhaba mustafa ',
    'beşiktaş fener ',
    'diyet listesi ',
    'flutter list ',
    'merhaba mustafa ',
    'beşiktaş fener ',
    'diyet listesi ',
    'flutter list ',
    'merhaba mustafa ',
    'beşiktaş fener ',
    'diyet listesi ',
    'flutter list ',
  ];

  void _showFullText(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: ProjectColors.backgroundCream,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Detaylar',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 16.h),
              Container(
                constraints: BoxConstraints(maxHeight: 400.h),
                child: SingleChildScrollView(
                  child: Text(
                    text * 5,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProjectColors.mainAvocado,
                  foregroundColor: ProjectColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Kapat'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorilerim',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(12.w),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: constraints.maxWidth / 2,
                mainAxisExtent: 250.h,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
              ),
              itemCount: _favoriteDiets.length,
              itemBuilder: (context, index) {
                final favoriteDiet = _favoriteDiets[index];
                return InkWell(
                  onTap: () => _showFullText(context, favoriteDiet),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          ProjectColors.lightAvocado.withOpacity(0.9),
                          ProjectColors.accentCoral.withOpacity(0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: ProjectColors.darkAvocado.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.favorite,
                            color: ProjectColors.white,
                            size: 24.w,
                          ),
                          SizedBox(height: 8.h),
                          Expanded(
                            child: Text(
                              favoriteDiet * 10,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: ProjectColors.white,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}