import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:aesd_app/services/session/storage_auth_token_session.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class HTTPClient {
  /*
    ***CLIENT SENDER***

    classe de l'objet qui servira à éffectuer les requêtes http.
    Elle permet de gérer les erreurs et de récupérer les données.

    * baseUrl         : Url de base de l'api distant.
    * headers         : Headers de la requête.
    * timeout         : Temps maximum avant d'attente
  */

  String baseUrl = "http://192.168.1.10:8000/api/v1";
  Duration timeout = const Duration(seconds: 10);
  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'accept': 'application/json',
  };
  
  final client = http.Client();

  Future get(String path, Map<String, String> data) async {
    /*
    * Méthode de récupération des données.
    */
    try{

      String parameters = "";

      // obtenir les paramètres de la requête
      if (data.isNotEmpty) {
        data.forEach((key, value){
          parameters += "$key=$value&";
        });
      }

      // envoie de la requête
      return await http.get(
        Uri.parse("$baseUrl/$path?$parameters"), // Url de la requête
        headers: headers // en-tête de la requête
      ).timeout(timeout);
    } on TimeoutException catch(e){
      e.printError();
    } on HttpException catch(e){
      e.printError();
    } catch (e) {
      e.printError();
    }
  }

  Future<http.Response?> post(String path, Map<String, dynamic> data) async {
    /*
    * Méthode de création de données sans envoie de fichier
    */
    try{
      String datas = json.encode(data);

      return await http.post(
        Uri.parse('$baseUrl/$path'),
        headers: headers,
        body: datas // corps de la requête avec les données à envoyer
      ).timeout(timeout);
    } on HttpException catch(e){
      e.printError();
    }
    return null;
  }

  Future<http.StreamedResponse?> multipart(String path, Map data) async {
    /*
    * Méthode de création de données avec envoie de fichiers
    */
    try {
      var request = http.MultipartRequest("post", Uri.parse("$baseUrl/$path"));

      // remplissage de l'en-tête
      headers.forEach((key, value) {
        request.headers[key] = value;
      });

      http.StreamedResponse? response;

      // envoie des données en vérifiant leurs types
      data.forEach((key, value) async {

        // envoie des fichiers
        if (value is File) {
          request.files.add(
            await http.MultipartFile.fromPath(key, value.path)
          );
        }

        // envoie des autres types de données
        else {
          request.fields[key] = value;
        }

        response = await request.send().timeout(timeout); // envoie de la requête
      });
      
      return response;
    } on TimeoutException catch (e) {
      e.printError();
    } 
    on HttpException catch(e){
      e.printError();
    }
    return null;
  }
}

Future<HTTPClient> getClient() async {
  HTTPClient client = HTTPClient();

  final authToken = await StorageAuthTokenSession.getFormSecureStorage();

  if (authToken.token != '' && authToken.type != '') {
    client.headers['Authorization'] = '${authToken.type} ${authToken.token}';
  }

  return client;
}