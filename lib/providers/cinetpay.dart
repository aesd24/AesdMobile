import 'dart:convert';
import 'package:aesd_app/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class CinetPay extends ChangeNotifier{
  final _apiUrl = Uri.parse("https://api-checkout.cinetpay.com/v2/payment");
  final _apiKey = "14638022065a1ece323e8456.99379118";
  final _siteID = "617170";
  final _channels = 'ALL';
  final headers = {
    'Content-Type': 'application/json',
  };

  makePayment(BuildContext context, {
    required int amount,
    required String description,
    required String notifyUrl,
    required String returnUrl,
  }) async {
    // utilisateur connecté
    final user = Provider.of<User>(context, listen: false).user;

    Map<String, dynamic> body = {
      'apikey' : _apiKey,
      'site_id' : _siteID,
      'transaction_id': 'transac${const Uuid().v6()}',
      'channels' : _channels,
      "amount": amount,
      "currency": "XOF",
      "description": description,
      "customer_id": user.id,
      "customer_name": user.name.split(" ").last,
      "customer_surname": user.name.split(" ").first,
      "customer_email": user.email,
      "customer_phone_number": "+225${user.phone}",
      "customer_address": "Abidjan, Côte d'Ivoire",
      "customer_city": "Abidjan",
      "customer_country": "CI",
      "customer_state": "CI",
      "customer_zip_code": "xxxxx",
      "notify_url": "https://www.eglisesetserviteursdedieu.com/api/v1/notifyPayment",
      "return_url": "https://www.eglisesetserviteursdedieu.com/api/v1/returnPayment"
    };
    return await http.post(_apiUrl, headers: headers, body: jsonEncode(body));
  }
}