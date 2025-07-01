part of '../regional_fat_burning.dart';


class InteractiveSvgBody extends StatelessWidget {
  const InteractiveSvgBody({
    required this.svgString,
    required this.onTapRegion,
    required this.gender,
    super.key,
  });

  final String svgString;
  final void Function(String) onTapRegion;
  final String gender;

  Map<String, Offset> get _regionCenters => gender == ProjectStrings.male
      ? {
          // Center points for male body diagram
          BodyRegions.face: const Offset(0.5, 0.075),
          BodyRegions.chest: const Offset(0.5, 0.23),
          BodyRegions.belly: const Offset(0.5, 0.36),
          BodyRegions.hip: const Offset(0.5, 0.45),
          BodyRegions.armLeft: const Offset(0.34, 0.35),
          BodyRegions.armRight: const Offset(0.66, 0.35),
          BodyRegions.legLeft: const Offset(0.44, 0.71),
          BodyRegions.legRight: const Offset(0.56, 0.71),
        }
      : {
          // Center points for female body diagram
          BodyRegions.face: const Offset(0.5, 0.075),
          BodyRegions.chest: const Offset(0.5, 0.22),
          BodyRegions.belly: const Offset(0.5, 0.32),
          BodyRegions.hip: const Offset(0.5, 0.42),
          BodyRegions.armLeft: const Offset(0.37, 0.35),
          BodyRegions.armRight: const Offset(0.63, 0.35),
          BodyRegions.legLeft: const Offset(0.44, 0.72),
          BodyRegions.legRight: const Offset(0.56, 0.72),
        };

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth * 0.95;
        final maxHeight = constraints.maxHeight * 0.95;

        return Stack(
          alignment: Alignment.center,
          children: [
            // SVG image
            SizedBox(
              width: maxWidth,
              height: maxHeight,
              child: SvgPicture.string(svgString),
            ),

            // Clickable target points
            ..._regionCenters.entries.map((entry) {
              return _buildTargetPoint(entry.key, entry.value, maxWidth, maxHeight);
            }),
          ],
        );
      },
    );
  }

  Widget _buildTargetPoint(String regionId, Offset center, double width, double height) {
    final pointSize = 28.w;
    final innerPointSize = 6.w;
    final borderWidth = 1.5.w;
    final blurRadius = 6.w;
    final spreadRadius = 1.w;

    return Positioned(
      left: center.dx * width - (pointSize / 2),
      top: center.dy * height - (pointSize / 2),
      child: GestureDetector(
        onTap: () => onTapRegion(regionId),
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: pointSize,
          height: pointSize,
          decoration: BoxDecoration(
            color: ProjectColors.green.withValues(alpha: 0.3),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.green.shade600, width: borderWidth),
            boxShadow: [
              BoxShadow(
                color: ProjectColors.green.withValues(alpha: 0.4),
                blurRadius: blurRadius,
                spreadRadius: spreadRadius,
              ),
            ],
          ),
          child: Center(
            child: Container(
              width: innerPointSize,
              height: innerPointSize,
              decoration: const BoxDecoration(
                color: ProjectColors.earthBrown,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
