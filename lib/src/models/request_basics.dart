///The UI model for summary of a request
class RequestBasics {
  ///The UI model for summary of a request
  RequestBasics({
    required this.baseUrl,
    required this.requestPath,
    required this.method,
    required this.headers,
    required this.body,
    required this.contentType,
    required this.queryParameters,
    required this.connectionTimeout,
    required this.receiveTimeout,
    required this.sendTimeout,
    required this.responseType,
  });

  ///Base url of a request
  final String baseUrl;
  ///Timeout in milliseconds for opening url
  final int connectionTimeout;
  ///Path of the url that starts after [baseUrl]
  final String requestPath;
  ///Response body
  final String body;
  ///Content-Type of the request
  final String? contentType;
  ///All headers sent with request
  final Map<String, dynamic> headers;
  ///Timeout in milliseconds for sending data
  final int sendTimeout;
  ///The type of data that the server will respond with
  final String responseType;
  ///Timeout in milliseconds for receiving data.
  final int receiveTimeout;
  ///Query parameters sent with request
  final Map<String, dynamic> queryParameters;
  ///Method of request such as GET, POST etc
  final String method;
}
