import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:tractian/src/core/exceptions/failure.dart';
import 'package:tractian/src/models/asset.dart';
import 'package:tractian/src/models/company.dart';
import 'package:tractian/src/models/location.dart';

import './company_repository.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  final Dio _dio = Dio();

  @override
  Future<List<Company>> getCompanies() async {
    try {
      final Response(:data) =
          await _dio.get('https://fake-api.tractian.com/companies');
      return data?.map<Company>((e) => Company.fromMap(e)).toList() ?? [];
    } catch (e, s) {
      log('Error fetching companies', error: e, stackTrace: s);
      throw Failure('Erro ao buscar empresas');
    }
  }

  @override
  Future<List<Asset>> getAllAssetsByCompany(String id) async {
    try {
      final Response(:data) =
          await _dio.get('https://fake-api.tractian.com/companies/$id/assets');
      return data?.map<Asset>((e) => Asset.fromMap(e)).toList() ?? [];
    } catch (e, s) {
      log('Error fetching locations', error: e, stackTrace: s);
      throw Failure('Erro ao buscar locais');
    }
  }

  @override
  Future<List<Location>> getAllLocationsByCompany(String id) async {
    try {
      final Response(:data) = await _dio
          .get('https://fake-api.tractian.com/companies/$id/locations');
      return data
              ?.map<Location>((e) => Location.fromMap(e))
              .toList()
              .reversed
              .toList() ??
          [];
    } catch (e, s) {
      log('Error fetching locations', error: e, stackTrace: s);
      throw Failure('Erro ao buscar locais');
    }
  }
}
