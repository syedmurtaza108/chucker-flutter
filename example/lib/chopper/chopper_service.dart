import 'package:chopper/chopper.dart';
import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:http/http.dart' as http;

part 'chopper_service.chopper.dart';

@ChopperApi()
abstract class ChopperApiService extends ChopperService {
  @GET(path: 'https://jsonplaceholder.typicode.com/posts/1')
  Future<Response<dynamic>> get();

  @GET(path: 'https://jsonplaceholder.typicode.com/error')
  Future<Response<dynamic>> getError();

  @GET(path: 'https://jsonplaceholder.typicode.com/posts?userId=1')
  Future<Response<dynamic>> getWithParams();

  @POST(path: 'https://jsonplaceholder.typicode.com/posts')
  Future<Response<dynamic>> post(@Body() dynamic body);

  @PUT(path: 'https://jsonplaceholder.typicode.com/posts/1')
  Future<Response<dynamic>> put(@Body() Map<String, dynamic> body);

  @DELETE(path: 'https://jsonplaceholder.typicode.com/posts/1')
  Future<Response<dynamic>> delete();

  @PATCH(path: 'https://jsonplaceholder.typicode.com/posts/1')
  Future<Response<dynamic>> patch(@Body() Map<String, dynamic> body);

  @POST(path: 'https://freeimage.host/api/1/upload')
  @multipart
  Future<Response<dynamic>> imageUpload(
    @PartFile('source') http.MultipartFile body, {
    @Part('key') String key = '6d207e02198a847aa98d0a2a901485a5',
  });

  static ChopperApiService create() {
    final client = ChopperClient(
      services: [
        _$ChopperApiService(),
      ],
      interceptors: [
        ChuckerHttpLoggingInterceptor(),
        ChuckerChopperInterceptor(),
      ],
    );
    return _$ChopperApiService(client);
  }
}
