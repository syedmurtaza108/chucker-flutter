import 'package:chucker_flutter/chucker_flutter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class UserSearch extends StatefulWidget {
  UserSearch({Key? key}) : super(key: key);

  @override
  State createState() => _UserSearchState();
}

class _UserSearchState extends State {
  Dio? dio;
  bool isLoading = false;
  bool isSearching = false;
  String? errorMessage;

  late final _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.github.com/',
      sendTimeout: const Duration(seconds: 50).inMilliseconds,
      connectTimeout: const Duration(seconds: 50).inMilliseconds,
      receiveTimeout: const Duration(seconds: 50).inMilliseconds,
    ),
  );

  @override
  void initState() {
    super.initState();
    BaseOptions options = BaseOptions(baseUrl: 'https://api.github.com/');
    dio = Dio(options);
    _dio.interceptors.add(ChuckerDioInterceptor());
  }

  Future getUser(String name) async {
    print('get çalıştı');
    setState(() {
      isLoading = true;
    });
    try {
      final response = await _dio?.get('users/$name');
      _dio?.options.headers["user-agent"] = "request";
      if (response?.statusCode == 200) {
        print('data geldi');
        print('data ');
      }
      setState(() {
        isLoading = false;
        errorMessage = null;
      });
    } on DioError catch (e) {
      setState(() {
        errorMessage = e.response?.statusMessage;
        isLoading = false;
      });
      print('Error Message ${e.response?.statusMessage}');
      print(e.response?.headers);
      print(e.response?.requestOptions);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isSearching
          ? AppBar(
// The search area here
              backgroundColor: Colors.black,
              title: Container(
                width: double.infinity,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: TextField(
                    onChanged: (word) {
                      if (word != '') {
                        getUser(word);
                        print('kelime $word');
                      }
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              isSearching = false;
                              isLoading = false;
                            });
                          },
                        ),
                        hintText: 'Search...',
                        border: InputBorder.none),
                  ),
                ),
              ))
          : AppBar(
              backgroundColor: Colors.black,
              title: const Text('Search User'),
              actions: [
                  IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = true;
                        });
                      },
                      icon: const Icon(Icons.search))
                ]),
      body: isLoading == true
          ? Container(
              alignment: Alignment.center,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CircularProgressIndicator(),
                  )
                ],
              ),
            )
          : SizedBox(),
    );
  }
}
