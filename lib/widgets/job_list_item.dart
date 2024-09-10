import 'package:aesd_app/models/job_model.dart';
import 'package:aesd_app/screens/job_show.dart';
import 'package:aesd_app/utils/constants.dart';
import 'package:flutter/material.dart';

class JobListItem extends StatelessWidget {
  JobModel job;

  JobListItem({super.key, 
    required this.job,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JobShow(
              job: job,
            ),
          ),
        )
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: Card(
          margin: EdgeInsets.zero,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12.0),
              topRight: Radius.circular(12.0),
            ),
          ),
          color: Theme.of(context).cardColor,
          elevation: 0.8,
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: double.infinity,
            ),
            margin: const EdgeInsets.only(right: 16, left: 16),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job.contract.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: kSecondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    job.shortDescription,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
