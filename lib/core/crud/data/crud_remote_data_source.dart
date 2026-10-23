import 'package:dio/dio.dart';
import 'package:pennypincher_pro/core/crud/data/item_json_codec.dart';
import 'package:pennypincher_pro/core/crud/domain/crud_item.dart';
import 'package:pennypincher_pro/core/network/api_envelope.dart';

/// REST calls of an item resource at [path]: list, create,
/// update and delete. Every method throws `AppException` on failure.
class CrudRemoteDataSource<T extends CrudItem, D> {
  CrudRemoteDataSource(this._dio, {required this.path, required this.codec});

  final Dio _dio;
  final String path;
  final ItemJsonCodec<T, D> codec;

  /// `GET <path>`.
  Future<List<T>> getAll() async {
    final response = await ApiEnvelope.send(() => _dio.get<Object?>(path));
    return ApiEnvelope.parseList(response.data, codec.fromJson);
  }

  /// `POST <path>`.
  Future<T> create(D draft) => _parsed(
        () => _dio.post<Object?>(path, data: codec.toJson(draft)),
      );

  /// `PUT <path>/{id}`.
  Future<T> update(String id, D draft) => _parsed(
        () => _dio.put<Object?>(_itemPath(id), data: codec.toJson(draft)),
      );

  /// `DELETE <path>/{id}`.
  Future<void> delete(String id) =>
      ApiEnvelope.send(() => _dio.delete<Object?>(_itemPath(id)));

  String _itemPath(String id) => '$path/${Uri.encodeComponent(id)}';

  Future<T> _parsed(Future<Response<Object?>> Function() request) async {
    final response = await ApiEnvelope.send(request);
    return ApiEnvelope.parseData(response.data, codec.fromJson);
  }
}
