import 'package:aesd_app/screens/actualities_forums_screen.dart';
import 'package:aesd_app/screens/courses_screen.dart';
import 'package:aesd_app/screens/donation_list.dart';
import 'package:aesd_app/screens/jobs_screen.dart';
import 'package:aesd_app/screens/home_screen.dart';
import 'package:aesd_app/screens/quiz_list.dart';

final routes = {
  HomeScreen.routeName: (_) => const HomeScreen(),
  ActualitiesForumsScreen.routeName: (_) => const ActualitiesForumsScreen(),
  CoursesScreen.routeName: (_) => const CoursesScreen(),
  JobsScreen.routeName: (_) => const JobsScreen(),
  DonationList.routeName: (_) => const DonationList(),
  QuizList.routeName: (_) => const QuizList(),
};
