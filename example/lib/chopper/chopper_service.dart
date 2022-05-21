import 'package:chopper/chopper.dart';
import 'package:chucker_flutter/chucker_flutter.dart';

part 'chopper_service.chopper.dart';

@ChopperApi()
abstract class ChopperApiService extends ChopperService {
  @Get(path: '/posts/1')
  Future<Response<dynamic>> get();

  @Get(path: '/error')
  Future<Response<dynamic>> getError();

  @Get(path: '/posts?userId=1')
  Future<Response<dynamic>> getWithParams();

  @Post(path: '/posts')
  Future<Response<dynamic>> post(@Body() dynamic body);

  @Put(path: '/posts/1')
  Future<Response<dynamic>> put(@Body() Map<String, dynamic> body);

  @Delete(path: '/posts/1')
  Future<Response<dynamic>> delete();

  @Patch(path: '/posts/1')
  Future<Response<dynamic>> patch(@Body() Map<String, dynamic> body);

  static ChopperApiService create() {
    final client = ChopperClient(
        baseUrl: 'https://jsonplaceholder.typicode.com',
        services: [
          _$ChopperApiService(),
        ],
        interceptors: [
          HttpLoggingInterceptor(),
          ChuckerChopperInterceptor(),
        ]);
    return _$ChopperApiService(client);
  }
}
