import 'package:elder_guard_app/app/theme/app_colors.dart';
import 'package:elder_guard_app/features/health_profile/presentation/widgets/health_profile_overview_card.dart';
import 'package:elder_guard_app/features/health_profile/presentation/widgets/health_profile_section_card.dart';
import 'package:elder_guard_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HealthProfileScreen extends StatelessWidget {
  const HealthProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.creamLight,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: AppColors.deepTeal,
        title: Text(
          l10n.menuHealthProfileTitle,
          style: GoogleFonts.merriweather(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 18),
            child: Text(
              l10n.healthProfileDemoDescription,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
            ),
          ),
          HealthProfileOverviewCard(
            demoBadge: l10n.healthProfileDemoBadge,
            name: l10n.healthProfileDemoName,
            ageLabel: l10n.healthProfileAgeValue(
              l10n.healthProfileAgeLabel,
              78,
            ),
            bloodTypeLabel: l10n.healthProfileFieldValue(
              l10n.healthProfileBloodTypeLabel,
              'O+',
            ),
            careLevelLabel: l10n.healthProfileFieldValue(
              l10n.healthProfileCareLevelLabel,
              l10n.healthProfileCareLevelValue,
            ),
          ),
          const SizedBox(height: 18),
          HealthProfileSectionCard(
            icon: Icons.monitor_heart_outlined,
            title: l10n.healthProfileVitalsSection,
            children: [
              HealthProfileInfoRow(
                label: l10n.healthProfileHeartRateLabel,
                value: l10n.healthProfileHeartRateValue(74),
              ),
              HealthProfileInfoRow(
                label: l10n.healthProfileBloodPressureLabel,
                value: '128/82 mmHg',
              ),
              HealthProfileInfoRow(
                label: l10n.healthProfileSpo2Label,
                value: l10n.healthProfileSpo2Value(97),
              ),
              HealthProfileInfoRow(
                label: l10n.healthProfileWeightLabel,
                value: l10n.healthProfileWeightValue(58),
              ),
            ],
          ),
          const SizedBox(height: 14),
          HealthProfileSectionCard(
            icon: Icons.medical_information_outlined,
            title: l10n.healthProfileConditionsSection,
            children: [
              HealthProfileTagWrap(
                tags: [
                  l10n.healthProfileConditionHypertension,
                  l10n.healthProfileConditionArthritis,
                  l10n.healthProfileConditionMemory,
                ],
              ),
              const SizedBox(height: 16),
              HealthProfileInfoRow(
                label: l10n.healthProfileAllergyLabel,
                value: l10n.healthProfileAllergyValue,
              ),
              HealthProfileInfoRow(
                label: l10n.healthProfileLastCheckupLabel,
                value: l10n.healthProfileLastCheckupValue,
              ),
            ],
          ),
          const SizedBox(height: 14),
          HealthProfileSectionCard(
            icon: Icons.medication_outlined,
            title: l10n.healthProfileMedicationSection,
            children: [
              HealthProfileInfoRow(
                label: l10n.healthProfileMedicationMorningLabel,
                value: l10n.healthProfileMedicationMorningValue,
              ),
              HealthProfileInfoRow(
                label: l10n.healthProfileMedicationEveningLabel,
                value: l10n.healthProfileMedicationEveningValue,
              ),
            ],
          ),
          const SizedBox(height: 14),
          HealthProfileSectionCard(
            icon: Icons.contact_phone_outlined,
            title: l10n.healthProfileEmergencySection,
            children: [
              HealthProfileInfoRow(
                label: l10n.healthProfileEmergencyContactLabel,
                value: l10n.healthProfileEmergencyContactValue,
              ),
              HealthProfileInfoRow(
                label: l10n.healthProfileEmergencyPhoneLabel,
                value: l10n.healthProfileEmergencyPhoneValue,
              ),
              HealthProfileInfoRow(
                label: l10n.healthProfileAddressLabel,
                value: l10n.healthProfileAddressValue,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
