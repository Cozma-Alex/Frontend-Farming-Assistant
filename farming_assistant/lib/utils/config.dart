import 'dart:io';

class APIConfig {
  //For testing purposes, this is the IP address of the machine running the backend server on your local network
  //Likely to be changed to an actual domain name in the end
  //!-Change to your own IP address-!
  static const String hostname = 'axxpro360.tplinkdns.com';
  static String ip = '192.168.0.47';
  static const String port = '6666';
  static String baseURI = 'http://$ip:$port/api';

  APIConfig(){
      if(hostname != '') {
        resolveHostname();
      }
  }

  void resolveHostname() async {
    if(hostname != ''){
      try {
        List<InternetAddress> addresses = await InternetAddress.lookup(hostname);
        for (var address in addresses) {
          ip = address.address;
        }
      } catch (e) {
        throw Exception('Failed to resolve hostname: $e');
      }
    }
  }


}
