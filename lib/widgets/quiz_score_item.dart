import 'package:aesd_app/models/participant_model.dart';
import 'package:flutter/material.dart';

class QuizScoreItem extends StatelessWidget {
  final ParticipantModel participant;
  final int rang;

  const QuizScoreItem({
    super.key,
    required this.participant,
    required this.rang,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Text(
          rang.toString(),
          style: const TextStyle(
            fontSize: 35,
          ),
        ),
        title: Text(participant.user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${participant.correctQuestionTotal} En ${participant.time} Sécondes')
          ],
        ),
      ),
    );
  }
}
