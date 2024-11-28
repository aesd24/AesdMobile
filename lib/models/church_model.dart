import 'package:aesd_app/models/dictionary.dart';
import 'package:aesd_app/models/programm_model.dart';
import 'package:aesd_app/models/servant_model.dart';
import 'package:flutter/material.dart';

class ChurchModel {
  late int? id;
  late String name;
  late String phone;
  late String email;
  late String address;
  late String description;
  late String logo;
  late String cover;
  late String image;
  late Dictionary type;
  late List<ServantModel> servants = [];
  late ServantModel? mainServant;
  late ProgrammModel? programm;

  ChurchModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = id == null ? "" : json['name'];
    image =
        'https://bretagneromantique.fr/wp-content/uploads/2021/04/IMG_4463-scaled.jpg';
    email = json['email'] ?? "";
    logo = json['logo_url'] ?? "";
    cover = json['cover_url'] ?? "";
    address = json['address'] ?? "";
    description = json['description'] ?? "";
    phone = id == null ? "" : "${json['dial_code']} + ${json['phone']}";
    type = Dictionary.fromJson(json['type'] ?? {});
    mainServant = json['main_servant'] != null
        ? ServantModel.fromJson(json['main_servant'])
        : null;
    json['servants']?.forEach((d) {
      servants.add(ServantModel.fromJson(d));
    });
    programm = json['program'] != null
        ? ProgrammModel.fromJson(json['program'])
        : null;
  }

  Widget card(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: logo != "" ? NetworkImage(logo) : const AssetImage("assets/images/bg-5.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(.8),
              Colors.black.withOpacity(.1)
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      mainServant != null ? mainServant!.name : "Inconnu",
                      style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        color: Colors.white60,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Icon(Icons.location_pin, color: Colors.white60, size: 18),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            address,
                            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                              color: Colors.white60,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ChurchPaginator {
  late List<ChurchModel> churches;
  late int currentPage;
  late int totalPages;

  ChurchPaginator.fromJson(Map<String, dynamic> json) {
    churches =
        (json['data'] as List).map((e) => ChurchModel.fromJson(e)).toList();
    currentPage = json['current_page'] ?? 0;
    totalPages = json['total_pages'] ?? 1;
  }
}
