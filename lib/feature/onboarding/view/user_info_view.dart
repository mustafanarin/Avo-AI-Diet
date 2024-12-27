import 'package:avo_ai_diet/product/constants/enum/app_radius.dart';
import 'package:avo_ai_diet/product/constants/project_colors.dart';
import 'package:avo_ai_diet/product/widgets/project_button.dart';
import 'package:avo_ai_diet/product/widgets/project_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CalorieCalculatorPage extends StatefulWidget {
  const CalorieCalculatorPage({super.key});

  @override
  State<CalorieCalculatorPage> createState() => _CalorieCalculatorPageState();
}

class _CalorieCalculatorPageState extends State<CalorieCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Form değerleri
  String? gender;
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();
  String? activityLevel;
  String? goal;

  // Focus nodelar
  final ageFocus = FocusNode();
  final heightFocus = FocusNode();
  final weightFocus = FocusNode();

  // Aktivite seviyeleri
  final List<String> activityLevels = [
    'Sedanter (hareketsiz yaşam)',
    'Hafif aktif (haftada 1-3 gün egzersiz)',
    'Orta aktif (haftada 3-5 gün egzersiz)',
    'Çok aktif (haftada 6-7 gün egzersiz)',
    'Profesyonel sporcu seviyesi',
  ];

  // Hedefler
  final List<String> goals = [
    'Kilo vermek',
    'Kilo korumak',
    'Kilo almak',
  ];

  @override
  void initState() {
    super.initState();
    // TextField değişikliklerini dinle
    ageController.addListener(_onFormChanged);
    heightController.addListener(_onFormChanged);
    weightController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    setState(() {}); // Form değiştiğinde UI'ı güncelle
  }

  @override
  void dispose() {
    ageController.removeListener(_onFormChanged);
    heightController.removeListener(_onFormChanged);
    weightController.removeListener(_onFormChanged);
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    ageFocus.dispose();
    heightFocus.dispose();
    weightFocus.dispose();
    super.dispose();
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 0:
        return gender != null &&
            ageController.text.trim().isNotEmpty &&
            heightController.text.trim().isNotEmpty &&
            weightController.text.trim().isNotEmpty;
      case 1:
        return activityLevel != null;
      case 2:
        return goal != null;
      default:
        return false;
    }
  }

  bool _validatePreviousSteps(int targetStep) {
    // Hedef step'e kadar olan tüm step'lerin validasyonunu kontrol et
    for (var i = 0; i <= targetStep; i++) {
      switch (i) {
        case 0:
          if (!(gender != null &&
              ageController.text.trim().isNotEmpty &&
              heightController.text.trim().isNotEmpty &&
              weightController.text.trim().isNotEmpty)) {
            return false;
          }
        case 1:
          if (!(activityLevel != null)) {
            return false;
          }
        case 2:
          if (!(goal != null)) {
            return false;
          }
      }
    }
    return true;
  }

  StepState _getStepState(int step) {
    if (_currentStep > step) {
      return StepState.complete;
    }
    if (_currentStep == step) {
      return StepState.editing;
    }
    return StepState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kalori Hesaplayıcı',
          style: TextStyle(
            color: ProjectColors.forestGreen,
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: ProjectColors.backgroundCream,
      body: Form(
        key: _formKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: ProjectColors.forestGreen,
            ),
          ),
          child: Stepper(
            currentStep: _currentStep,
            elevation: 0,
            onStepTapped: (step) {
              // Sadece bir önceki step'e dönmeye izin ver
              if (step < _currentStep && _validatePreviousSteps(step)) {
                setState(() => _currentStep = step);
              }
            },
            controlsBuilder: (context, details) {
              final isCurrentStepValid = _validateCurrentStep();

              return Padding(
                padding: EdgeInsets.only(top: 20.h),
                child: Column(
                  children: [
                    ProjectButton(
                      text: _currentStep == 2 ? 'HESAPLA' : 'DEVAM ET',
                      onPressed: isCurrentStepValid
                          ? () {
                              if (_currentStep < 2) {
                                setState(() {
                                  _currentStep += 1;
                                });
                              } else {
                                calculateCalories();
                              }
                            }
                          : null,
                      isEnabled: isCurrentStepValid,
                    ),
                    if (_currentStep > 0) ...[
                      SizedBox(height: 12.h),
                      BackButton(
                        onPressed: () {
                          setState(() {
                            _currentStep -= 1;
                          });
                        },
                      ),
                    ],
                  ],
                ),
              );
            },
            steps: [
              Step(
                state: _getStepState(0),
                title: Text(
                  'Kişisel Bilgiler',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: ProjectColors.forestGreen,
                  ),
                ),
                content: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: ProjectColors.white,
                        borderRadius: AppRadius.circularSmall(),
                        border: Border.all(color: ProjectColors.grey200),
                      ),
                      child: Column(
                        children: [
                          RadioListTile<String>(
                            title: const Text(
                              'Erkek',
                            ),
                            value: 'Erkek',
                            groupValue: gender,
                            activeColor: ProjectColors.forestGreen,
                            onChanged: (String? value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                          const Divider(height: 1),
                          RadioListTile<String>(
                            title: const Text('Kadın'),
                            value: 'Kadın',
                            groupValue: gender,
                            activeColor: ProjectColors.forestGreen,
                            onChanged: (String? value) {
                              setState(() {
                                gender = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: ageController,
                      focusNode: ageFocus,
                      labelText: 'Yaş',
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: heightController,
                      focusNode: heightFocus,
                      labelText: 'Boy (cm)',
                    ),
                    SizedBox(height: 16.h),
                    _buildTextField(
                      controller: weightController,
                      focusNode: weightFocus,
                      labelText: 'Kilo (kg)',
                    ),
                  ],
                ),
                isActive: _currentStep >= 0,
              ),
              Step(
                state: _getStepState(1),
                title: Text(
                  'Aktivite Seviyesi',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: ProjectColors.forestGreen,
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: AppRadius.circularSmall(),
                    border: Border.all(color: ProjectColors.grey200),
                  ),
                  child: Column(
                    children: activityLevels.map((level) {
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(level),
                            value: level,
                            groupValue: activityLevel,
                            activeColor: ProjectColors.forestGreen,
                            onChanged: (String? value) {
                              setState(() {
                                activityLevel = value;
                              });
                            },
                          ),
                          if (level != activityLevels.last) const Divider(height: 1),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                isActive: _currentStep >= 1,
              ),
              Step(
                state: _getStepState(2),
                title: Text(
                  'Hedef',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                    color: ProjectColors.forestGreen,
                  ),
                ),
                content: Container(
                  decoration: BoxDecoration(
                    color: ProjectColors.white,
                    borderRadius: AppRadius.circularSmall(),
                    border: Border.all(color: ProjectColors.grey200),
                  ),
                  child: Column(
                    children: goals.map((g) {
                      return Column(
                        children: [
                          RadioListTile<String>(
                            title: Text(g),
                            value: g,
                            groupValue: goal,
                            activeColor: ProjectColors.forestGreen,
                            onChanged: (String? value) {
                              setState(() {
                                goal = value;
                              });
                            },
                          ),
                          if (g != goals.last) const Divider(height: 1),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                isActive: _currentStep >= 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String labelText,
  }) {
    return ProjectTextField(
      controller: controller,
      focusNode: focusNode,
      labelText: labelText,
    );
  }

  void calculateCalories() {
    if (gender == null ||
        ageController.text.isEmpty ||
        heightController.text.isEmpty ||
        weightController.text.isEmpty ||
        activityLevel == null ||
        goal == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text(
            'Uyarı',
            style: TextStyle(
              color: ProjectColors.forestGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text('Lütfen tüm alanları doldurunuz'),
          actions: [
            TextButton(
              child: const Text(
                'TAMAM',
                style: TextStyle(color: ProjectColors.forestGreen),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
      return;
    }

    double bmr;
    if (gender == 'Erkek') {
      bmr = 88.362 +
          (13.397 * double.parse(weightController.text)) +
          (4.799 * double.parse(heightController.text)) -
          (5.677 * double.parse(ageController.text));
    } else {
      bmr = 447.593 +
          (9.247 * double.parse(weightController.text)) +
          (3.098 * double.parse(heightController.text)) -
          (4.330 * double.parse(ageController.text));
    }

    double activityMultiplier;
    switch (activityLevel) {
      case 'Sedanter (hareketsiz yaşam)':
        activityMultiplier = 1.2;
      case 'Hafif aktif (haftada 1-3 gün egzersiz)':
        activityMultiplier = 1.375;
      case 'Orta aktif (haftada 3-5 gün egzersiz)':
        activityMultiplier = 1.55;
      case 'Çok aktif (haftada 6-7 gün egzersiz)':
        activityMultiplier = 1.725;
      case 'Profesyonel sporcu seviyesi':
        activityMultiplier = 1.9;
      default:
        activityMultiplier = 1.2;
    }

    var totalCalories = bmr * activityMultiplier;

    switch (goal) {
      case 'Kilo vermek':
        totalCalories -= 500;
      case 'Kilo almak':
        totalCalories += 500;
      default:
        break;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 20.h),
              decoration: BoxDecoration(
                color: ProjectColors.grey200,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Text(
              'Günlük Kalori İhtiyacınız',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: ProjectColors.forestGreen,
              ),
            ),
            SizedBox(height: 20.h),
            _ResultRow(
              label: 'Bazal Metabolizma Hızı (BMR):',
              value: '${bmr.toStringAsFixed(0)} kcal',
            ),
            SizedBox(height: 12.h),
            _ResultRow(
              label: 'Günlük Kalori İhtiyacı:',
              value: '${totalCalories.toStringAsFixed(0)} kcal',
              highlight: true,
            ),
            SizedBox(height: 20.h),
            ProjectButton(
              text: 'TAMAM',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16.sp),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: highlight ? ProjectColors.forestGreen : Colors.black,
          ),
        ),
      ],
    );
  }
}
