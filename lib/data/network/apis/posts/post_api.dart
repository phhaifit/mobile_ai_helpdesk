import 'dart:async';

import '/core/data/network/dio/dio_client.dart';
import '/data/network/constants/endpoints.dart';
import '/domain/entity/post/post_list.dart';

class PostApi {
  // dio instance
  final DioClient _dioClient;

  PostApi(this._dioClient);

  /// Returns list of post in response
  Future<PostList> getPosts() async {
    try {
      final res = await _dioClient.dio.get(Endpoints.getPosts);
      return PostList.fromJson(res.data as List<dynamic>);
    } catch (e) {
      rethrow;
    }
  }

  /// sample api call with default rest client
  //   Future<PostList> getPosts() async {
  //     try {
  //       final res = await _restClient.get(Endpoints.getPosts);
  //       return PostList.fromJson(res.data);
  //     } catch (e) {
  //       print(e.toString());
  //       throw e;
  //     }
  //   }
}
