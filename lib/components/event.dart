import "package:flutter/material.dart";

Widget customEventBox(BuildContext context,{
  required String title,
  required String date,
  double? height
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 5),
    width: 300,
    height: height,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: const DecorationImage(
            image: AssetImage("assets/event.jpg"), fit: BoxFit.cover)),
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.green.withOpacity(.7),
                Colors.green.withOpacity(.3),
              ])),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Text(
            date,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Colors.white60),
          )
        ],
      ),
    ),
  );
}
