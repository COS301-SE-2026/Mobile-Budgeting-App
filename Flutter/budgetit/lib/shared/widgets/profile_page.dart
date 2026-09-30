import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../database/app_database.dart';
import '../../services/friend_service.dart';
import '../../utils/app_colour.dart';
import '../../utils/app_dialog_style.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const _red = Color(0xFFCF6679);

  Future<void> _handleLogout(BuildContext context) async {
    final auth = context.read<AppAuthProvider>();
    await auth.signOut();
    if (context.mounted) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  void _handleGoToSignUp(BuildContext context) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    context.read<AppAuthProvider>().backToLogin();
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final auth = context.watch<AppAuthProvider>();

    return Scaffold(
      backgroundColor: colours.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: colours.primary,
                        border: Border.all(color: Colors.black, width: 3),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(4, 4)),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back,
                        color: colours.cardText,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text('PROFILE', style: colours.h2),
                ],
              ),
              const SizedBox(height: 36),
              Align(
                child: Container(
                  width: 96,
                  height: 96,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: colours.primary,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                    ],
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 52,
                    color: colours.cardText,
                  ),
                ),
              ),
              const SizedBox(height: 26),

              // Identity line — email for logged-in users, guest label otherwise
              if (auth.isLoggedIn && auth.currentUser != null)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: colours.primary,
                    border: Border.all(color: Colors.black, width: 4),
                    boxShadow: const [
                      BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'USERNAME',
                        style: colours.h4.copyWith(color: colours.cardText),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        auth.currentUser!.email,
                        style: colours.b1.copyWith(
                          color: colours.cardText,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 16,
                      color: colours.textPrimary.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Guest User',
                      style: colours.b1.copyWith(
                        color: colours.textPrimary.withValues(alpha: 0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),

              const SizedBox(height: 20),
              const _ProfileDetailsCard(),
              const SizedBox(height: 20),
              if (auth.isLoggedIn) ...[
                FutureBuilder<String>(
                  future: FriendService.instance.getMyFriendCode(),
                  builder: (context, snapshot) {
                    final code = snapshot.data;
                    return Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colours.primary,
                        border: Border.all(color: Colors.black, width: 4),
                        boxShadow: const [
                          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'YOUR FRIEND CODE',
                            style: colours.h4.copyWith(color: colours.cardText),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  snapshot.connectionState ==
                                          ConnectionState.waiting
                                      ? 'LOADING...'
                                      : code ?? 'UNAVAILABLE',
                                  style: colours.h2.copyWith(
                                    color: colours.cardText,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: 'Copy friend code',
                                onPressed: code == null
                                    ? null
                                    : () async {
                                        await Clipboard.setData(
                                          ClipboardData(text: code),
                                        );
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('Friend code copied'),
                                          ),
                                        );
                                      },
                                icon: Icon(
                                  Icons.copy,
                                  color: code == null
                                      ? colours.cardText.withValues(alpha: 0.4)
                                      : colours.cardText,
                                ),
                              ),
                            ],
                          ),
                          if (snapshot.hasError) ...[
                            const SizedBox(height: 6),
                            Text(
                              'Could not load the code. Check the Friends server and try again.',
                              style: colours.b1.copyWith(color: colours.error),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
              ],

              // Sign Up button — only shown for guest users, sits above Log Out
              if (auth.status == AuthStatus.skipped) ...[
                ElevatedButton.icon(
                  onPressed: () => _handleGoToSignUp(context),
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text('Sign Up'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colours.primary,
                    foregroundColor: colours.cardText,
                    textStyle: colours.b1.copyWith(fontWeight: FontWeight.bold),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Colors.black, width: 3),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              OutlinedButton.icon(
                onPressed: auth.isLoading ? null : () => _handleLogout(context),
                icon: auth.isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: _red,
                        ),
                      )
                    : const Icon(Icons.logout, color: _red),
                label: Text(
                  'Log Out',
                  style: colours.b1.copyWith(
                    color: auth.isLoading ? _red.withValues(alpha: 0.5) : _red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    color: auth.isLoading ? _red.withValues(alpha: 0.4) : _red,
                    width: 3,
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  shape: const RoundedRectangleBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _incomeRanges = [
  'Under R5 000',
  'R5 000 - R15 000',
  'R15 000 - R30 000',
  'R30 000 - R50 000',
  'Over R50 000',
];

const _months = [
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

String _formatDate(DateTime date) =>
    '${date.day} ${_months[date.month - 1]} ${date.year}';

class _ProfileDetails {
  const _ProfileDetails({
    this.name,
    this.phone,
    this.dateOfBirth,
    this.incomeRange,
  });

  final String? name;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? incomeRange;
}

class _ProfileDetailsCard extends StatefulWidget {
  const _ProfileDetailsCard();

  @override
  State<_ProfileDetailsCard> createState() => _ProfileDetailsCardState();
}

class _ProfileDetailsCardState extends State<_ProfileDetailsCard> {
  _ProfileDetails? _details;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final settings = context.read<AppDatabase>().settingsDao;
    final name = await settings.getSetting('profile_name');
    final phone = await settings.getSetting('profile_phone');
    final dateOfBirth = await settings.getSetting('profile_date_of_birth');
    final incomeRange = await settings.getSetting('profile_income_range');
    if (!mounted) return;
    setState(() {
      _details = _ProfileDetails(
        name: name,
        phone: phone,
        dateOfBirth: dateOfBirth == null
            ? null
            : DateTime.tryParse(dateOfBirth),
        incomeRange: incomeRange,
      );
    });
  }

  Future<void> _edit() async {
    final details = _details;
    if (details == null) return;
    final updated = await showDialog<_ProfileDetails>(
      context: context,
      builder: (_) => _EditDetailsDialog(initial: details),
    );
    if (updated == null || !mounted) return;

    final settings = context.read<AppDatabase>().settingsDao;
    await settings.setSetting('profile_name', updated.name ?? '');
    final phone = updated.phone;
    if (phone == null || phone.isEmpty) {
      await settings.deleteSetting('profile_phone');
    } else {
      await settings.setSetting('profile_phone', phone);
    }
    final dateOfBirth = updated.dateOfBirth;
    if (dateOfBirth != null) {
      await settings.setSetting(
        'profile_date_of_birth',
        dateOfBirth.toIso8601String(),
      );
    }
    final incomeRange = updated.incomeRange;
    if (incomeRange != null) {
      await settings.setSetting('profile_income_range', incomeRange);
    }
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Details updated')));
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;
    final details = _details;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colours.primary,
        border: Border.all(color: Colors.black, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black, offset: Offset(6, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'YOUR DETAILS',
                  style: colours.h4.copyWith(color: colours.cardText),
                ),
              ),
              IconButton(
                tooltip: 'Edit details',
                onPressed: details == null ? null : _edit,
                icon: Icon(Icons.edit_outlined, color: colours.cardText),
              ),
            ],
          ),
          if (details == null)
            Text(
              'LOADING...',
              style: colours.b1.copyWith(color: colours.cardText),
            )
          else ...[
            _detailRow(context, 'Name', details.name),
            _detailRow(context, 'Phone', details.phone),
            _detailRow(
              context,
              'Date of birth',
              details.dateOfBirth == null
                  ? null
                  : _formatDate(details.dateOfBirth!),
            ),
            _detailRow(context, 'Monthly income', details.incomeRange),
          ],
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String? value) {
    final colours = context.colours;
    final isSet = value != null && value.isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              label,
              style: colours.b1.copyWith(color: colours.cardText),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              isSet ? value : 'Not set',
              textAlign: TextAlign.right,
              style: colours.b1.copyWith(
                color: isSet
                    ? colours.cardText
                    : colours.cardText.withValues(alpha: 0.6),
                fontWeight: isSet ? FontWeight.bold : FontWeight.normal,
                fontStyle: isSet ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EditDetailsDialog extends StatefulWidget {
  const _EditDetailsDialog({required this.initial});

  final _ProfileDetails initial;

  @override
  State<_EditDetailsDialog> createState() => _EditDetailsDialogState();
}

class _EditDetailsDialogState extends State<_EditDetailsDialog> {
  late final TextEditingController _nameController = TextEditingController(
    text: widget.initial.name ?? '',
  );
  late final TextEditingController _phoneController = TextEditingController(
    text: widget.initial.phone ?? '',
  );
  late DateTime? _dateOfBirth = widget.initial.dateOfBirth;
  late String? _incomeRange = widget.initial.incomeRange;

  Color get _cream => context.colours.cardText;
  Color get _mutedCream => _cream.withValues(alpha: 0.6);

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter your name')));
      return;
    }
    Navigator.of(context).pop(
      _ProfileDetails(
        name: name,
        phone: _phoneController.text.trim(),
        dateOfBirth: _dateOfBirth,
        incomeRange: _incomeRange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colours = context.colours;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 430),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colours.primary,
          border: Border.all(color: Colors.black, width: 4),
          boxShadow: const [
            BoxShadow(color: Colors.black, offset: Offset(6, 6)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('EDIT DETAILS', style: colours.h2.copyWith(color: _cream)),
              const SizedBox(height: 18),
              _label('NAME'),
              const SizedBox(height: 8),
              _textField(
                controller: _nameController,
                hint: 'Your name',
                icon: Icons.person_outline,
                capitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              _label('PHONE NUMBER (OPTIONAL)'),
              const SizedBox(height: 8),
              _textField(
                controller: _phoneController,
                hint: '071 234 5678',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              _label('DATE OF BIRTH'),
              const SizedBox(height: 8),
              _dateField(),
              const SizedBox(height: 16),
              _label('MONTHLY INCOME'),
              const SizedBox(height: 8),
              for (final range in _incomeRanges) ...[
                _incomeOption(range),
                const SizedBox(height: 8),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _cream,
                      side: const BorderSide(color: Colors.black, width: 3),
                      shape: const RoundedRectangleBorder(),
                    ),
                    child: Text(
                      'Cancel',
                      style: colours.b1.copyWith(color: _cream),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _save,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _cream,
                      foregroundColor: colours.primary,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(color: Colors.black, width: 3),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: colours.b1.copyWith(
                        color: colours.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: context.colours.h4.copyWith(color: _cream),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization capitalization = TextCapitalization.none,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cream.withValues(alpha: 0.1),
        border: Border.all(color: Colors.black, width: 4),
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

  Widget _dateField() {
    final date = _dateOfBirth;
    return GestureDetector(
      onTap: _pickDateOfBirth,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: _cream.withValues(alpha: 0.1),
          border: Border.all(color: Colors.black, width: 4),
        ),
        child: Row(
          children: [
            Icon(Icons.cake_outlined, color: _cream, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                date == null ? 'Select your date of birth' : _formatDate(date),
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

  Widget _incomeOption(String range) {
    final green = context.colours.primary;
    final isSelected = _incomeRange == range;
    return GestureDetector(
      onTap: () => setState(() => _incomeRange = range),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? _cream : _cream.withValues(alpha: 0.1),
          border: Border.all(color: Colors.black, width: 4),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                range,
                style: context.colours.h2.copyWith(
                  color: isSelected ? green : _cream,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.check_box : Icons.check_box_outline_blank,
              color: isSelected ? green : _cream,
              size: 20,
            ),
          ],
        ),
      ),
    );
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
    if (picked != null && mounted) {
      setState(
        () => _dateOfBirth = DateTime(picked.year, picked.month, picked.day),
      );
    }
  }
}
