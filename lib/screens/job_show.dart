import 'package:aesd_app/models/job_model.dart';
import 'package:flutter/material.dart';

class JobShow extends StatefulWidget {
  final JobModel job;

  const JobShow({super.key, required this.job});

  @override
  _JobShowState createState() => _JobShowState();
}

class _JobShowState extends State<JobShow> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text('Opportunités'),
      ),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          const SizedBox(height: 35),
          Column(
            children: [
              Text(
                widget.job.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
            ],
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Contrat: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      widget.job.contract.description,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      'Niveau d\'étude: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      widget.job.studyLevel.description,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      'Expérience: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      widget.job.experience.description,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text(
                      'Date limite: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    Text(
                      widget.job.deadline,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  indent: 10.0,
                  endIndent: 20.0,
                  thickness: 1,
                ),
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.job.description,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Profile POste',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.job.postProfile,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Exigence',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.job.requirement,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
