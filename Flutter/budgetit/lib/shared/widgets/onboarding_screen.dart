import 'package:budgetit/database/app_database.dart';
import 'package:budgetit/database/schema.dart';
import 'package:budgetit/utils/app_colour.dart';
import 'package:budgetit/utils/app_dialog_style.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.onComplete});

  final VoidCallback? onComplete;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  static const _stepCount = 4;
  static const _incomeRanges = [
    'Under R5 000',
    'R5 000 - R15 000',
    'R15 000 - R30 000',
    'R30 000 - R50 000',
    'Over R50 000',
  ];
  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _goalNameController = TextEditingController();
  final _goalTargetController = TextEditingController();

  int _step = 0;
  DateTime? _dateOfBirth;
  String? _incomeRange;
  bool _saving = false;

  Color get _green => context.colours.primary;
  Color get _cream => context.colours.cardText;
  Color get _softCream => _cream.withValues(alpha: 0.8);
  Color get _mutedCream => _cream.withValues(alpha: 0.6);
  Color get _borderColor => Colors.black;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _goalNameController.dispose();
    _goalTargetController.dispose();
    super.dispose();
  }

  String get _stepTitle {
    switch (_step) {
      case 0:
        return 'About You';
      case 1:
        return 'Your Birthday';
      case 2:
        return 'Your Income';
      default:
        return 'Your First Goal';
    }
  }

  String get _stepSubtitle {
    switch (_step) {
      case 0:
        return 'Tell us what to call you';
      case 1:
        return 'Pick your date of birth';
      case 2:
        return 'Choose your monthly income range';
      default:
        return 'Optional. You can add goals any time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _green,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildProgress(),
                    const SizedBox(height: 24),
                    _buildCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Text(
            'Budget IT',
            style: context.colours.title.copyWith(color: _cream, fontSize: 20),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          _stepTitle,
          textAlign: TextAlign.center,
          style: context.colours.h2.copyWith(
            color: _cream,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _stepSubtitle,
          textAlign: TextAlign.center,
          style: context.colours.h2.copyWith(
            color: _softCream,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildProgress() {
    return Column(
      children: [
        Row(
          children: [
            for (var i = 0; i < _stepCount; i++) ...[
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 12,
                  decoration: BoxDecoration(
                    color: i <= _step ? _cream : _cream.withValues(alpha: 0.2),
                    border: Border.all(color: _borderColor, width: 3),
                  ),
                ),
              ),
              if (i < _stepCount - 1) const SizedBox(width: 8),
            ],
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'STEP ${_step + 1} OF $_stepCount',
          style: context.colours.h2.copyWith(
            color: _mutedCream,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildCard() {
    return Container(
      decoration: BoxDecoration(
        color: context.colours.blendedprimary,
        border: Border.all(color: _borderColor, width: 4),
        boxShadow: [BoxShadow(color: _borderColor, offset: const Offset(6, 6))],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ..._buildStepFields(),
          const SizedBox(height: 24),
          _buildPrimaryButton(),
          if (_step > 0) ...[
            const SizedBox(height: 12),
            _buildBackButton(),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildStepFields() {
    switch (_step) {
      case 0:
        return [
          _buildLabel('NAME'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nameController,
            hint: 'Your name',
            icon: Icons.person_outline,
            capitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 16),
          _buildLabel('PHONE NUMBER (OPTIONAL)'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _phoneController,
            hint: '071 234 5678',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ];
      case 1:
        return [
          _buildLabel('DATE OF BIRTH'),
          const SizedBox(height: 8),
          _buildDateField(),
          const SizedBox(height: 10),
          _buildBenefit(
            'Your age helps Budget IT suggest savings goals and tips that suit your stage of life.',
          ),
        ];
      case 2:
        return [
          _buildLabel('MONTHLY INCOME'),
          const SizedBox(height: 8),
          for (final range in _incomeRanges) ...[
            _buildIncomeOption(range),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 2),
          _buildBenefit(
            'Your income range helps Budget IT suggest realistic budget limits for your spending.',
          ),
        ];
      default:
        return [
          _buildLabel('GOAL NAME'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _goalNameController,
            hint: 'e.g. Emergency fund',
            icon: Icons.flag_outlined,
            capitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          _buildLabel('TARGET AMOUNT'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _goalTargetController,
            hint: 'e.g. 5000',
            icon: Icons.savings_outlined,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 10),
          _buildBenefit('Leave this blank to skip. It will not affect your setup.'),
        ];
    }
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: context.colours.h2.copyWith(
        color: _cream,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildBenefit(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(Icons.info_outline, color: _mutedCream, size: 14),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: context.colours.h2.copyWith(
              color: _softCream,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cream.withValues(alpha: 0.1),
        border: Border.all(color: _borderColor, width: 4),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: capitalization,
        style: context.colours.h2.copyWith(
          color: _cream,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: context.colours.h2.copyWith(
            color: _mutedCream,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(icon, color: _cream, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    final date = _dateOfBirth;
    return GestureDetector(
      onTap: _pickDateOfBirth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: _cream.withValues(alpha: 0.1),
          border: Border.all(color: _borderColor, width: 4),
        ),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, color: _cream, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date == null
                    ? 'Select your date of birth'
                    : '${date.day} ${_months[date.month - 1]} ${date.year}',
                style: context.colours.h2.copyWith(
                  color: date == null ? _mutedCream : _cream,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.calendar_month, color: _cream, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeOption(String range) {
    final isSelected = _incomeRange == range;
    return GestureDetector(
      onTap: () => setState(() => _incomeRange = range),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _cream : _cream.withValues(alpha: 0.1),
          border: Border.all(color: _borderColor, width: 4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                range,
                style: context.colours.h2.copyWith(
                  color: isSelected ? _green : _cream,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? _green : _cream,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryButton() {
    final isLast = _step == _stepCount - 1;
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saving ? null : (isLast ? _finish : _next),
        style: ElevatedButton.styleFrom(
          backgroundColor: _cream,
          foregroundColor: _green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: _borderColor, width: 4),
          ),
          disabledBackgroundColor: _cream.withValues(alpha: 0.53),
        ),
        child: _saving
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: _green),
              )
            : Text(
                isLast ? 'Finish →' : 'Next →',
                style: context.colours.h2.copyWith(
                  color: _green,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
      ),
    );
  }

  Widget _buildBackButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: _saving ? null : () => setState(() => _step--),
        style: OutlinedButton.styleFrom(
          foregroundColor: _cream,
          side: BorderSide(color: _borderColor, width: 4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: const RoundedRectangleBorder(),
        ),
        child: Text(
          '← Back',
          style: context.colours.h2.copyWith(
            color: _cream,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _next() {
    if (_step == 0 && _nameController.text.trim().isEmpty) {
      _showMessage('Please enter your name');
      return;
    }
    if (_step == 1 && _dateOfBirth == null) {
      _showMessage('Please select your date of birth');
      return;
    }
    if (_step == 2 && _incomeRange == null) {
      _showMessage('Please choose your monthly income range');
      return;
    }
    setState(() => _step++);
  }

  Decimal? _parseAmount(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return null;
    try {
      final value = Decimal.parse(text);
      return value <= Decimal.zero ? null : value;
    } catch (_) {
      return null;
    }
  }

  Future<void> _finish() async {
    final goalName = _goalNameController.text.trim();
    final goalTargetText = _goalTargetController.text.trim();
    final wantsGoal = goalName.isNotEmpty || goalTargetText.isNotEmpty;
    final goalTarget = _parseAmount(goalTargetText);

    if (wantsGoal && goalTarget == null) {
      _showMessage('Enter a target amount greater than zero');
      return;
    }

    setState(() => _saving = true);
    try {
      final db = context.read<AppDatabase>();
      final settings = db.settingsDao;
      final dateOfBirth = _dateOfBirth!;
      await settings.setSetting('profile_name', _nameController.text.trim());
      final phone = _phoneController.text.trim();
      if (phone.isNotEmpty) {
        await settings.setSetting('profile_phone', phone);
      }
      await settings.setSetting(
        'profile_date_of_birth',
        DateTime(
          dateOfBirth.year,
          dateOfBirth.month,
          dateOfBirth.day,
        ).toIso8601String(),
      );
      await settings.setSetting('profile_income_range', _incomeRange!);
      if (wantsGoal && goalTarget != null) {
        await db.goalDao.insertGoalTemplate(
          name: goalName.isEmpty ? null : goalName,
          targetAmount: goalTarget,
          periodType: PeriodType.monthly,
        );
      }
      await settings.setOnboardingComplete(complete: true);
      if (!mounted) return;
      final onComplete = widget.onComplete;
      if (onComplete != null) {
        onComplete();
      } else {
        await Navigator.of(context).maybePop();
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _pickDateOfBirth() async {
    final colours = context.colours;
    final now = DateTime.now();
    final lastDate = DateTime(now.year, now.month, now.day);
    var draftDate = _dateOfBirth ?? DateTime(now.year - 25, now.month, 1);

    final picked = await showDialog<DateTime>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final cardColor = isDark ? colours.blendedprimary : colours.secondary;
          final cardTextColor = isDark ? colours.secondary : colours.background;

          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border.all(color: Colors.black, width: 4),
                boxShadow: const [
                  BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SELECT DATE OF BIRTH',
                    style: colours.h2.copyWith(color: cardTextColor),
                  ),
                  const SizedBox(height: 12),
                  Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: ColorScheme.fromSeed(
                        seedColor: cardTextColor,
                        primary: colours.background,
                        onPrimary: colours.secondary,
                        surface: cardColor,
                        onSurface: cardTextColor,
                        brightness: Theme.of(context).brightness,
                      ),
                      datePickerTheme: DatePickerThemeData(
                        backgroundColor: cardColor,
                        headerBackgroundColor: cardColor,
                        headerForegroundColor: cardTextColor,
                        toggleButtonTextStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                        subHeaderForegroundColor: cardTextColor,
                        weekdayStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        dayStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                        ),
                        dayForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : isDark
                              ? null
                              : colours.secondary,
                        ),
                        dayBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? (isDark ? colours.background : colours.primary)
                              : isDark
                              ? null
                              : colours.background,
                        ),
                        todayForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : isDark
                              ? null
                              : colours.secondary,
                        ),
                        todayBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? (isDark ? colours.background : colours.primary)
                              : isDark
                              ? null
                              : colours.background,
                        ),
                        yearStyle: colours.b5.copyWith(
                          color: cardTextColor,
                          fontSize: 14,
                        ),
                        yearForegroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? colours.cardText
                              : isDark
                              ? null
                              : colours.secondary,
                        ),
                        yearBackgroundColor: WidgetStateProperty.resolveWith(
                          (states) => states.contains(WidgetState.selected)
                              ? (isDark ? colours.background : colours.primary)
                              : isDark
                              ? null
                              : colours.background,
                        ),
                        dayShape: WidgetStateProperty.resolveWith((states) {
                          return RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                            side: states.contains(WidgetState.selected)
                                ? BorderSide(
                                    color: Colors.black,
                                    width: isDark ? 3 : 2,
                                  )
                                : BorderSide.none,
                          );
                        }),
                        todayBorder: BorderSide(
                          color: isDark ? Colors.black : cardTextColor,
                          width: isDark ? 3 : 2,
                        ),
                      ),
                    ),
                    child: CalendarDatePicker(
                      initialDate: draftDate,
                      firstDate: DateTime(1900),
                      lastDate: lastDate,
                      initialCalendarMode: DatePickerMode.year,
                      onDateChanged: (date) =>
                          setDialogState(() => draftDate = date),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        style: AppDialogStyle.isDark(context)
                            ? AppDialogStyle.cancel(context)
                            : TextButton.styleFrom(
                                foregroundColor: cardTextColor,
                                side: const BorderSide(
                                  color: Colors.black,
                                  width: 3,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                        child: Text(
                          'Cancel',
                          style: colours.b1.copyWith(color: cardTextColor),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () =>
                            Navigator.of(dialogContext).pop(draftDate),
                        style: AppDialogStyle.isDark(context)
                            ? AppDialogStyle.primary(context)
                            : ElevatedButton.styleFrom(
                                backgroundColor: cardTextColor,
                                foregroundColor: cardColor,
                                textStyle: colours.b1.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                  side: BorderSide(
                                    color: Colors.black,
                                    width: 3,
                                  ),
                                ),
                              ),
                        child: const Text('Apply'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (picked != null && mounted) setState(() => _dateOfBirth = picked);
  }
}
