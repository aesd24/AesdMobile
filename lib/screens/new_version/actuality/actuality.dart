import 'package:flutter/material.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      extendBodyBehindAppBar: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * .35,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/news.jpeg"), fit: BoxFit.cover),
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.black.withOpacity(.7),
                  Colors.black.withOpacity(.1)
                ], begin: Alignment.bottomCenter, end: Alignment.topCenter),
              ),
              child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Flexible(
                    child: Text(
                      "Titre de l'article",
                      style: Theme.of(context)
                          .textTheme
                          .headlineLarge!
                          .copyWith(
                              color: Colors.white, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.clip,
                    ),
                  )),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(15),
            child: Text("Contenue de l'article"),
          )
        ],
      ),
    );
  }
}
