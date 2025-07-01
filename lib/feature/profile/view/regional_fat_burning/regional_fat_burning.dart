import 'package:avo_ai_diet/feature/profile/cubit/regional_fat_burning_cubit.dart';
import 'package:avo_ai_diet/feature/profile/state/regional_fat_burning_state.dart';
import 'package:avo_ai_diet/feature/profile/view/regional_fat_burning/mixin/regional_fat_burning_mixin.dart';
import 'package:avo_ai_diet/product/constants/body_regions.dart';
import 'package:avo_ai_diet/product/constants/enum/general/json_name.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/constants/project_strings.dart';
import 'package:avo_ai_diet/product/utility/extensions/json_extension.dart';
import 'package:avo_ai_diet/product/utility/extensions/text_theme_extension.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

part './widgets/avo_advice.dart';
part './widgets/interactive_body_svg.dart';

final class RegionalFatBurning extends StatefulWidget {
  const RegionalFatBurning({super.key});

  @override
  State<RegionalFatBurning> createState() => _RegionalFatBurningState();
}

class _RegionalFatBurningState extends State<RegionalFatBurning> with RegionalFatBurningMixin {
  @override
  void initState() {
    super.initState();
    initRegionalFatBurning();
  }

  void _getAdvice() {
    final selectedRegions = getSelectedRegionNames();

    if (selectedRegions.isNotEmpty) {
      context.read<RegionalFatBurningCubit>().getAdvice(selectedRegions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedRegionNames = getSelectedRegionNames();

    return Scaffold(
      appBar: AppBar(
        title: const Text(ProjectStrings.regionalFatBurning),
        backgroundColor: ProjectColors.backgroundCream,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(
            Icons.arrow_back,
            color: ProjectColors.earthBrown,
          ),
        ),
      ),
      body: BlocConsumer<RegionalFatBurningCubit, RegionalFatBurningState>(
        listener: (context, state) {
          if (state.advice.isNotEmpty && !state.isLoading) {
            WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.65,
                  child: !isLoading && modifiedSvgString != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: InteractiveSvgBody(
                              svgString: modifiedSvgString!,
                              onTapRegion: toggleBodyPart,
                              gender: userGender,
                            ),
                          ),
                        )
                      : const Center(child: CircularProgressIndicator()),
                ),
                Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSelectedRegionsBox(selectedRegionNames),
                      ProjectButton(
                        text: state.isLoading
                            ? ProjectStrings.adviceGetting
                            : state.adviceReceived
                                ? ProjectStrings.adviceGot
                                : ProjectStrings.adviceGet,
                        onPressed: state.isLoading || state.adviceReceived ? null : _getAdvice,
                        isEnabled: selectedRegionNames.isNotEmpty && !state.isLoading && !state.adviceReceived,
                      ),
                      if (state.error.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(
                            state.error,
                            style: context.textTheme().bodySmall?.copyWith(
                                  color: ProjectColors.red,
                                ),
                          ),
                        ),
                      if (state.isLoading)
                        Center(
                          child: SizedBox(
                            height: 70.h,
                            width: 70.h,
                            child: Lottie.asset(
                              JsonName.avoWalk.path,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      if (state.advice.isNotEmpty) _AvoAdvice(state.advice),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSelectedRegionsBox(List<String> selectedRegionNames) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: ProjectColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: ProjectColors.black.withValues(alpha: 0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 16.sp,
            color: ProjectColors.earthBrown,
          ),
          children: [
            const TextSpan(
              text: ProjectStrings.selectedRegion,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: selectedRegionNames.isEmpty ? ProjectStrings.noRegionSelected : selectedRegionNames.join(', '),
            ),
          ],
        ),
      ),
    );
  }
}
