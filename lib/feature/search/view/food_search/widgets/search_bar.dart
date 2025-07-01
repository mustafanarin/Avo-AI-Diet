part of '../search_view.dart';

class _SearchBarSection extends StatelessWidget {
  const _SearchBarSection({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: ProjectColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ProjectColors.forestGreen.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
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
            hintText: ProjectStrings.enterFoodName,
            filled: true,
            fillColor: ProjectColors.white,
            suffixIcon: BlocBuilder<SearchCubit, SearchState>(
              builder: (context, state) {
                return state.query.isNotEmpty
                    ? IconButton(
                        onPressed: onClear,
                        icon: const Icon(Icons.clear),
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}