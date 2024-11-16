import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIConfig {
  //For testing purposes, this is the IP address of the machine running the backend server on your local network
  //Likely to be changed to an actual domain name in the end
  //!-Change to your own IP address-!
  static const String hostname = 'axxpro360.tplinkdns.com';
  static String ip = '192.168.0.47';
  static const String port = '6001';
  static String baseURI = 'http://$ip:$port/api';

  static void resolveHostname() async {
    if (hostname.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse('https://dns.google/resolve?name=$hostname&type=A'));
        if (response.statusCode == 200) {
          final jsonResponse = jsonDecode(response.body);
          final addresses = jsonResponse['Answer'];
          if (addresses != null && addresses.isNotEmpty) {
            ip = addresses[0]['data'];
            baseURI = 'http://$ip:$port/api';
          } else {
            throw Exception('No IP address found for hostname');
          }
        } else {
          throw Exception('Failed to resolve hostname: ${response.reasonPhrase}');
        }
      } catch (e) {
        throw Exception('Failed to resolve hostname: $e');
      }
    }
  }

}
