class RequestBasics {
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
  
  final String baseUrl;
  final int connectionTimeout;
  final String requestPath;
  final String body;
  final String? contentType;
  final Map<String, dynamic> headers;
  final int sendTimeout;
  final String responseType;
  final int receiveTimeout;
  final Map<String, dynamic> queryParameters;
  final String method;
}
