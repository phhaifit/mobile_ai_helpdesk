import 'dart:io';

import 'package:ai_helpdesk/core/domain/error/failure.dart';
import 'package:ai_helpdesk/domain/entity/account/account.dart';
import 'package:dartz/dartz.dart';

class AccountUpdateParams {
  final String? name;
  final String? email;
  final String? fullname;
  final String? phoneNumber;
  final String? username;

  const AccountUpdateParams({
    this.name,
    this.email,
    this.fullname,
    this.phoneNumber,
    this.username,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (fullname != null) 'fullname': fullname,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (username != null) 'username': username,
      };
}

abstract class AccountRepository {
  /// Fetch the current account via `/account/sso-validate`. Caches on success.
  Future<Either<Failure, Account>> getCurrent();

  /// Patch profile fields.
  Future<Either<Failure, void>> update(AccountUpdateParams params);

  /// Multipart upload for the account avatar.
  Future<Either<Failure, void>> uploadAvatar(File file);

  /// Last-known account from local cache.
  Future<Account?> loadCached();
}
