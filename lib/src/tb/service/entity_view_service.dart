import 'dart:convert';

import '../thingsboard_client_base.dart';
import '../http/http_utils.dart';
import '../model/model.dart';

PageData<EntityView> parseEntityViewPageData(Map<String, dynamic> json) {
  return PageData.fromJson(json, (json) => EntityView.fromJson(json));
}

class EntityViewService {
  final ThingsboardClient _tbClient;

  factory EntityViewService(ThingsboardClient tbClient) {
    return EntityViewService._internal(tbClient);
  }

  EntityViewService._internal(this._tbClient);

  Future<EntityView?> getEntityView(String entityViewId,
      {RequestConfig? requestConfig}) async {
    return nullIfNotFound(
      (RequestConfig requestConfig) async {
        var response = await _tbClient.get<Map<String, dynamic>>(
            '/api/entityView/$entityViewId',
            options: defaultHttpOptionsFromConfig(requestConfig));
        return response.data != null
            ? EntityView.fromJson(response.data!)
            : null;
      },
      requestConfig: requestConfig,
    );
  }

  Future<EntityView> saveEntityView(EntityView entityView,
      {RequestConfig? requestConfig}) async {
    var response = await _tbClient.post<Map<String, dynamic>>('/api/entityView',
        data: jsonEncode(entityView),
        options: defaultHttpOptionsFromConfig(requestConfig));
    return EntityView.fromJson(response.data!);
  }

  Future<void> deleteEntityView(String entityViewId,
      {RequestConfig? requestConfig}) async {
    await _tbClient.delete('/api/entityView/$entityViewId',
        options: defaultHttpOptionsFromConfig(requestConfig));
  }

  Future<PageData<EntityView>> getTenantEntityViews(PageLink pageLink,
      {String type = '', RequestConfig? requestConfig}) async {
    var queryParams = pageLink.toQueryParameters();
    queryParams['type'] = type;
    var response = await _tbClient.get<Map<String, dynamic>>(
        '/api/tenant/entityViews',
        queryParameters: queryParams,
        options: defaultHttpOptionsFromConfig(requestConfig));
    return _tbClient.compute(parseEntityViewPageData, response.data!);
  }

  Future<EntityView?> getTenantEntityView(String entityViewName,
      {RequestConfig? requestConfig}) async {
    return nullIfNotFound(
      (RequestConfig requestConfig) async {
        var response = await _tbClient.get<Map<String, dynamic>>(
            '/api/tenant/entityViews',
            queryParameters: {'entityViewName': entityViewName},
            options: defaultHttpOptionsFromConfig(requestConfig));
        return response.data != null
            ? EntityView.fromJson(response.data!)
            : null;
      },
      requestConfig: requestConfig,
    );
  }

  Future<PageData<EntityView>> getCustomerEntityViews(
      String customerId, PageLink pageLink,
      {String type = '', RequestConfig? requestConfig}) async {
    var queryParams = pageLink.toQueryParameters();
    queryParams['type'] = type;
    var response = await _tbClient.get<Map<String, dynamic>>(
        '/api/customer/$customerId/entityViews',
        queryParameters: queryParams,
        options: defaultHttpOptionsFromConfig(requestConfig));
    return _tbClient.compute(parseEntityViewPageData, response.data!);
  }

  Future<PageData<EntityView>> getUserEntityViews(PageLink pageLink,
      {String type = '', RequestConfig? requestConfig}) async {
    var queryParams = pageLink.toQueryParameters();
    queryParams['type'] = type;
    var response = await _tbClient.get<Map<String, dynamic>>(
        '/api/user/entityViews',
        queryParameters: queryParams,
        options: defaultHttpOptionsFromConfig(requestConfig));
    return _tbClient.compute(parseEntityViewPageData, response.data!);
  }

  Future<List<EntityView>> getEntityViewsByIds(List<String> entityViewIds,
      {RequestConfig? requestConfig}) async {
    var response = await _tbClient.get<List<dynamic>>('/api/entityViews',
        queryParameters: {'entityViewIds': entityViewIds.join(',')},
        options: defaultHttpOptionsFromConfig(requestConfig));
    return response.data!.map((e) => EntityView.fromJson(e)).toList();
  }

  Future<List<EntityView>> findByQuery(EntityViewSearchQuery query,
      {RequestConfig? requestConfig}) async {
    var response = await _tbClient.post<List<dynamic>>('/api/entityViews',
        data: jsonEncode(query),
        options: defaultHttpOptionsFromConfig(requestConfig));
    return response.data!.map((e) => EntityView.fromJson(e)).toList();
  }

  Future<PageData<EntityView>> getEntityViewsByEntityGroupId(
      String entityGroupId, PageLink pageLink,
      {RequestConfig? requestConfig}) async {
    var response = await _tbClient.get<Map<String, dynamic>>(
        '/api/entityGroup/$entityGroupId/entityViews',
        queryParameters: pageLink.toQueryParameters(),
        options: defaultHttpOptionsFromConfig(requestConfig));
    return _tbClient.compute(parseEntityViewPageData, response.data!);
  }

  Future<List<EntitySubtype>> getEntityViewTypes(
      {RequestConfig? requestConfig}) async {
    var response = await _tbClient.get<List<dynamic>>('/api/entityView/types',
        options: defaultHttpOptionsFromConfig(requestConfig));
    return response.data!.map((e) => EntitySubtype.fromJson(e)).toList();
  }
}
