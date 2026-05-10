import 'package:ai_helpdesk/core/stores/error/error_store.dart';
import 'package:ai_helpdesk/domain/entity/tenant/tenant.dart';
import 'package:ai_helpdesk/domain/entity/tenant_settings/tenant_settings.dart';
import 'package:ai_helpdesk/domain/repository/tenant/tenant_repository.dart';
import 'package:ai_helpdesk/presentation/auth/store/auth_store.dart';
import 'package:mobx/mobx.dart';

part 'tenant_store.g.dart';

class TenantStore = _TenantStore with _$TenantStore;

/// Manages tenant selection and loading.
/// Automatically reloads tenants when user authentication state changes,
/// ensuring tenants are available immediately after login without requiring
/// a manual page reload.
abstract class _TenantStore with Store {
  _TenantStore(this._tenantRepository, this._authStore, this._errorStore) {
    // Set up reaction to auto-load tenants when user signs in
    _authReaction = reaction(
      (_) => _authStore.isAuthenticated,
      (isAuthenticated) {
        if (isAuthenticated && tenantList.isEmpty) {
          loadTenants();
        }
      },
    );

    // If user is already authenticated (e.g., app restart after login),
    // load tenants immediately
    if (_authStore.isAuthenticated && tenantList.isEmpty) {
      loadTenants();
    }
  }

  final TenantRepository _tenantRepository;
  final AuthStore _authStore;
  final ErrorStore _errorStore;
  late final ReactionDisposer _authReaction;

  @observable
  Tenant? currentTenant;

  @observable
  ObservableList<Tenant> tenantList = ObservableList<Tenant>();

  @observable
  bool isLoading = false;

  void _upsertTenant(Tenant tenant) {
    final index = tenantList.indexWhere((item) => item.id == tenant.id);
    if (index >= 0) {
      tenantList[index] = tenant;
      return;
    }
    tenantList.add(tenant);
  }

  Tenant _normalizeCreatedTenant(Tenant created, {required String fallbackName}) {
    final normalizedName = created.name.trim().isEmpty
        ? fallbackName.trim()
        : created.name;
    if (normalizedName == created.name) {
      return created;
    }
    return Tenant(
      id: created.id,
      name: normalizedName,
      slug: created.slug,
      settings: created.settings,
      createdAt: created.createdAt,
    );
  }

  void _syncCurrentTenant(Tenant tenant) {
    final index = tenantList.indexWhere((item) => item.id == tenant.id);
    if (index >= 0) {
      tenantList[index] = tenant;
    }
    currentTenant = tenant;
  }

  @action
  Future<void> loadTenants() async {
    isLoading = true;
    try {
      final list = await _tenantRepository.getTenants();
      final cachedId = await _tenantRepository.getCachedTenantId();
      tenantList
        ..clear()
        ..addAll(list);
      Tenant? selected;
      if (cachedId != null) {
        for (final tenant in tenantList) {
          if (tenant.id == cachedId) {
            selected = tenant;
            break;
          }
        }
      }
      currentTenant = selected ?? (tenantList.isNotEmpty ? tenantList.first : null);
      await _tenantRepository.saveCachedTenantId(currentTenant?.id);
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> switchTenant(String tenantId) async {
    isLoading = true;
    try {
      final t = await _tenantRepository.getTenantById(tenantId);
      if (t != null) {
        currentTenant = t;
        await _tenantRepository.saveCachedTenantId(t.id);
      }
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> createTenant(Tenant tenant) async {
    isLoading = true;
    try {
      final created = await _tenantRepository.createTenant(tenant);
      final normalizedCreated = _normalizeCreatedTenant(
        created,
        fallbackName: tenant.name,
      );
      _upsertTenant(normalizedCreated);
      currentTenant = normalizedCreated;
      await _tenantRepository.saveCachedTenantId(normalizedCreated.id);
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<void> createTenantOnFirstLogin({required String name}) async {
    isLoading = true;
    try {
      final created = await _tenantRepository.createTenantOnFirstLogin(
        name: name,
      );
      final normalizedCreated = _normalizeCreatedTenant(
        created,
        fallbackName: name,
      );
      _upsertTenant(normalizedCreated);
      currentTenant = normalizedCreated;
      await _tenantRepository.saveCachedTenantId(normalizedCreated.id);
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> deleteTenant(String id) async {
    isLoading = true;
    try {
      final ok = await _tenantRepository.deleteTenant(id);
      if (!ok) {
        return;
      }
      tenantList.removeWhere((t) => t.id == id);
      if (currentTenant?.id == id) {
        currentTenant = tenantList.isNotEmpty ? tenantList.first : null;
      }
      await _tenantRepository.saveCachedTenantId(currentTenant?.id);
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateTenantName(String name) async {
    final tenant = currentTenant;
    final trimmedName = name.trim();
    if (tenant == null || trimmedName.isEmpty || tenant.name == trimmedName) {
      return false;
    }

    isLoading = true;
    try {
      final updated = await _tenantRepository.updateTenant(
        Tenant(
          id: tenant.id,
          name: trimmedName,
          slug: tenant.slug,
          settings: tenant.settings,
          createdAt: tenant.createdAt,
        ),
      );
      if (updated == null) {
        return false;
      }
      final index = tenantList.indexWhere((item) => item.id == updated.id);
      if (index >= 0) {
        tenantList[index] = updated;
      }
      currentTenant = updated;
      return true;
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshAutoResolutionSettings() async {
    final tenant = currentTenant;
    if (tenant == null) {
      return;
    }

    isLoading = true;
    try {
      final settings = await _tenantRepository.getTenantSettings(tenant.id);
      final mergedSettings = tenant.settings.copyWith(
        autoResolutionEnabled: settings.autoResolutionEnabled,
        autoResolutionTimeoutHours: settings.autoResolutionTimeoutHours,
      );
      _syncCurrentTenant(
        Tenant(
          id: tenant.id,
          name: tenant.name,
          slug: tenant.slug,
          settings: mergedSettings,
          createdAt: tenant.createdAt,
        ),
      );
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateAutoResolutionSettings({
    required bool enabled,
    required int? timeoutHours,
  }) async {
    final tenant = currentTenant;
    if (tenant == null) {
      return false;
    }

    if (enabled && (timeoutHours == null || timeoutHours <= 0)) {
      return false;
    }

    isLoading = true;
    try {
      final settings = await _tenantRepository.updateTenantSettings(
        tenantId: tenant.id,
        autoResolutionEnabled: enabled,
        autoResolutionTimeoutHours: enabled ? timeoutHours : null,
      );
      final mergedSettings = tenant.settings.copyWith(
        autoResolutionEnabled: settings.autoResolutionEnabled,
        autoResolutionTimeoutHours: settings.autoResolutionTimeoutHours,
      );

      _syncCurrentTenant(
        Tenant(
          id: tenant.id,
          name: tenant.name,
          slug: tenant.slug,
          settings: mergedSettings,
          createdAt: tenant.createdAt,
        ),
      );
      return true;
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<void> getTenantJoinInfo() async {
    try {
      return await _tenantRepository.getTenantJoinInfo();
    } catch (e) {
      _errorStore.setErrorMessage(e.toString());
    }
  }

  /// Clean up the auth reaction when store is disposed
  void dispose() {
    _authReaction();  // ReactionDisposer is a function, just call it
  }
}
