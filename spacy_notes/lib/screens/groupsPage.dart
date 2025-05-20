import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/models/team_model.dart';
import 'package:spacy_notes/providers/team_provider.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTeams = ref.watch(userTeamsStreamProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Groups',
        subTitle: 'Page',
        onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
      ),
      body: asyncTeams.when(
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(
              child: CustomText(
                text: "No groups joined yet!",
                color: AppColors.onPrimary,
                fontSize: 18,
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return _buildTeamCard(context, team);
            },
          );
        },
        loading:
            () => const Center(
              child: CircularProgressIndicator(color: AppColors.onSecondary),
            ),
        error:
            (e, _) => Center(
              child: CustomText(
                text: 'Error: $e',
                color: Colors.red,
                fontSize: 16,
              ),
            ),
      ),
    );
  }

  Widget _buildTeamCard(BuildContext context, TeamModel team) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/courses', arguments: team.id);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 25, 2, 52),
                const Color.fromRGBO(140, 18, 220, 1),
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.group, color: Colors.white),
              const SizedBox(width: 16),
              Expanded(
                child: CustomText(
                  text: team.name,
                  color: AppColors.onSecondary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'jersey',
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.onSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
