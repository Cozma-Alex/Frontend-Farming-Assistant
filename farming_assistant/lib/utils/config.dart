class APIConfig {

  //For testing purposes, this is the IP address of the machine running the backend server on your local network
  //Likely to be changed to an actual domain name in the end
  //!-Change to your own IP address-!
  static const String ip = '192.168.0.47';
  static const String port = '8080';
  static const String baseURI = 'http://$ip:$port/api';

}
