import 'package:aesd_app/screens/actualities_forums_screen.dart';
import 'package:aesd_app/screens/courses_screen.dart';
import 'package:aesd_app/screens/donation_list.dart';
import 'package:aesd_app/screens/jobs_screen.dart';
import 'package:aesd_app/screens/phone_book.dart';
import 'package:aesd_app/screens/quiz_list.dart';
import 'package:aesd_app/screens/ceremonies/ceremonies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class GridDashboard extends StatelessWidget {
  Items item1 = Items(
    title: "Annuaire",
    subtitle: "Églises, Serviteurs et Chantres",
    event: "",
    img: "assets/icons/book.svg",
    routeName: PhoneBook.routeName,
  );

  Items item2 = Items(
    title: "Don et partage",
    subtitle: "Faites parler votre coeur.",
    event: "",
    img: "assets/icons/donation.svg",
    routeName: DonationList.routeName,
  );
  Items item3 = Items(
    title: "Actualités & Forums",
    subtitle: "Actualité et discussion.",
    event: "",
    img: "assets/icons/news.svg",
    routeName: ActualitiesForumsScreen.routeName,
  );
  Items item4 = Items(
    title: "Cours biblique",
    subtitle: "En différé et directe.",
    event: "",
    img: "assets/icons/bible.svg",
    routeName: CoursesScreen.routeName,
  );
  Items item5 = Items(
    title: "Quiz",
    subtitle: "Tester votre connaissance.",
    event: "",
    img: "assets/icons/quiz.svg",
    routeName: QuizList.routeName,
  );
  Items item6 = Items(
    title: "Opportunités jeunes",
    subtitle: "Trouvez des Opportunités.",
    event: "+ 1000",
    img: "assets/icons/young.svg",
    routeName: JobsScreen.routeName,
  );
  Items item7 = Items(
    title: "Cérémonies",
    subtitle: "Regarder les cérémonies en différé",
    event: "",
    img: "assets/icons/church.svg",
    routeName: VideoList.routeName,
  );

  GridDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6, item7];
    var color = 0xffffffff;
    return Flexible(
      child: GridView.builder(
        padding: const EdgeInsets.only(left: 16, right: 16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1.0,
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          mainAxisExtent: 130,
        ),
        itemCount: myList.length,
        itemBuilder: (BuildContext context, int index) {
          var data = myList[index];
          return InkWell(
            onTap: () {
              if (index == 6){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const VideoList())
                );
              } else {
                Navigator.pushNamed(context, data.routeName);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(color),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(4, 6), // Shadow position
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  /*SizedBox(
                    height: 4,
                  ),*/
                  SvgPicture.asset(data.img, width: 30),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    data.title,
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.black87,
                            fontSize: 11,
                            fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    data.subtitle,
                    style: GoogleFonts.openSans(
                        textStyle: const TextStyle(
                            color: Colors.black38,
                            fontSize: 10,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  String routeName;

  Items({
    required this.title,
    required this.subtitle,
    required this.event,
    required this.img,
    required this.routeName,
  });
}
