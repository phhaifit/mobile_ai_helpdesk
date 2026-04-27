import 'dart:io';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/data/local/auth/auth_local_datasource.dart';
import 'package:ai_helpdesk/data/network/apis/account/account_api.dart';
import 'package:ai_helpdesk/data/network/stack_error_mapper.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:ai_helpdesk/domain/repository/account/account_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountApi _api;
  final AuthLocalDatasource _local;

  AccountRepositoryImpl(this._api, this._local);

  @override
  Future<Either<Failure, Account>> getCurrent() async {
    try {
      final json = await _api.ssoValidate();
      final data = json['data'];
      if (data is! Map<String, dynamic>) {
        return const Left(UnknownFailure('common_error_unknown'));
      }
      final account = Account.fromJson(data);
      await _local.saveAccount(account);
      return Right(account);
    } on DioException catch (e) {
      return Left(StackErrorMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> update(AccountUpdateParams params) async {
    try {
      await _api.updateMe(params.toJson());
      return const Right(null);
    } on DioException catch (e) {
      return Left(StackErrorMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> uploadAvatar(File file) async {
    try {
      await _api.uploadAvatar(file);
      return const Right(null);
    } on DioException catch (e) {
      return Left(StackErrorMapper.map(e));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Account?> loadCached() => _local.loadAccount();
}
