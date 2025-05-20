import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:spacy_notes/CustomWidgets/customAppBar.dart';
import 'package:spacy_notes/CustomWidgets/customText.dart';
import 'package:spacy_notes/core/constants/color_constants.dart';
import 'package:spacy_notes/models/team_model.dart';
import 'package:spacy_notes/providers/team_provider.dart';
import 'package:spacy_notes/screens/coursesPage.dart';

class GroupsPage extends ConsumerWidget {
  const GroupsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncTeams = ref.watch(userTeamsStreamProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: CustomAppBar(
        title: 'Groups',
        subTitle: 'Page',
        onPressed: () => Navigator.pushReplacementNamed(context, '/profile'),
      ),
      body: asyncTeams.when(
        data: (teams) {
          if (teams.isEmpty) {
            return const Center(
              child: Text(
                "No groups joined yet!",
                style: TextStyle(color: Colors.white),
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: teams.length,
            itemBuilder: (context, index) {
              final team = teams[index];
              return _buildTile(context, team);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error:
            (e, _) => Center(
              child: Text(
                'Error: $e',
                style: const TextStyle(color: Colors.red),
              ),
            ),
      ),
    );
  }

  Widget _buildTile(BuildContext context, TeamModel team) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, '/courses', arguments: team.id);
        },

        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.purple[200],
            border: Border.all(color: Colors.black),
            boxShadow: const [
              BoxShadow(color: Colors.black38, offset: Offset(2, 2)),
            ],
          ),
        ),
        title: CustomText(
          text: team.name,
          fontWeight: FontWeight.bold,
          color: AppColors.unselectedTaskColor,
        ),
      ),
    );
  }
}
