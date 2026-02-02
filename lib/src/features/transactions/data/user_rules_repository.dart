import 'dart:convert';
import 'package:flutter/foundation.dart' hide Category;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/category.dart';
import '../domain/subcategory.dart';

part 'user_rules_repository.g.dart';

@Riverpod(keepAlive: true)
Future<UserRulesRepository> userRulesRepository(Ref ref) async {
  final prefs = await SharedPreferences.getInstance();
  final repo = UserRulesRepository(prefs);
  repo.load(); // Load into memory
  return repo;
}

class UserRulesRepository {
  UserRulesRepository(this._prefs);
  final SharedPreferences _prefs;

  static const _overridesKey = 'categorization_overrides';
  static const _rulesKey = 'categorization_rules';
  static const _exclusionsKey = 'categorization_exclusions';

  // ID -> {category: 'food', subcategory: 'groceries'}
  Map<String, (Category, Subcategory)> _overridesCache = {};
  // Keyword -> {category: 'food', subcategory: 'groceries'}
  Map<String, (Category, Subcategory)> _rulesCache = {};
  // Set of ID
  Set<String> _exclusionsCache = {};

  void load() {
    // Load Overrides
    final overridesJson = _prefs.getString(_overridesKey);
    if (overridesJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(overridesJson);
        _overridesCache = decoded.map((key, value) {
          final cat = Category.values.byName(value['category']);
          final sub = Subcategory.values.byName(value['subcategory']);
          return MapEntry(key, (cat, sub));
        });
      } catch (e) {
        // Handle corruption?
        debugPrint('Error loading overrides: $e');
      }
    }

    // Load Rules
    final rulesJson = _prefs.getString(_rulesKey);
    if (rulesJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(rulesJson);
        _rulesCache = decoded.map((key, value) {
          final cat = Category.values.byName(value['category']);
          final sub = Subcategory.values.byName(value['subcategory']);
          return MapEntry(key, (cat, sub));
        });
      } catch (e) {
        debugPrint('Error loading rules: $e');
      }
    }

    // Load Exclusions
    final exclusionsList = _prefs.getStringList(_exclusionsKey);
    if (exclusionsList != null) {
      _exclusionsCache = exclusionsList.toSet();
    }
  }

  // --- Public Getters (Sync) ---

  (Category, Subcategory)? getOverride(String transactionId) {
    return _overridesCache[transactionId];
  }

  (Category, Subcategory)? getRule(String description) {
    // Simple contains check for each rule
    // Note: This iterate over all rules for every transaction.
    // If rules are many, this might be slow. But likely few.
    // Also, assumes "rule" key is the keyword to search for.

    // Sort logic? Longest match?
    // Let's iterate and return first match for now.
    final lowerDesc = description.toLowerCase();
    for (final entry in _rulesCache.entries) {
      if (lowerDesc.contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return null;
  }

  Map<String, (Category, Subcategory)> getAllRules() => Map.from(_rulesCache);
  Map<String, (Category, Subcategory)> getAllOverrides() =>
      Map.from(_overridesCache);

  bool isExcluded(String transactionId) {
    return _exclusionsCache.contains(transactionId);
  }

  Set<String> getAllExclusions() => Set.from(_exclusionsCache);

  // --- Public Setters (Async) ---

  Future<void> addOverride(
    String transactionId,
    Category category,
    Subcategory subcategory,
  ) async {
    _overridesCache[transactionId] = (category, subcategory);
    await _saveOverrides();
  }

  Future<void> addRule(
    String keyword,
    Category category,
    Subcategory subcategory,
  ) async {
    _rulesCache[keyword] = (category, subcategory);
    await _saveRules();
  }

  Future<void> removeRule(String keyword) async {
    _rulesCache.remove(keyword);
    await _saveRules();
  }

  Future<void> toggleExclusion(String transactionId) async {
    if (_exclusionsCache.contains(transactionId)) {
      _exclusionsCache.remove(transactionId);
    } else {
      _exclusionsCache.add(transactionId);
    }
    await _saveExclusions();
  }

  Future<void> clearAll() async {
    _overridesCache.clear();
    _rulesCache.clear();
    _exclusionsCache.clear();
    await _prefs.remove(_overridesKey);
    await _prefs.remove(_rulesKey);
    await _prefs.remove(_exclusionsKey);
  }

  // --- Internal Persistence ---

  Future<void> _saveOverrides() async {
    final encodable = _overridesCache.map((key, value) {
      return MapEntry(key, {
        'category': value.$1.name,
        'subcategory': value.$2.name,
      });
    });
    await _prefs.setString(_overridesKey, jsonEncode(encodable));
  }

  Future<void> _saveRules() async {
    final encodable = _rulesCache.map((key, value) {
      return MapEntry(key, {
        'category': value.$1.name,
        'subcategory': value.$2.name,
      });
    });
    await _prefs.setString(_rulesKey, jsonEncode(encodable));
  }

  Future<void> _saveExclusions() async {
    await _prefs.setStringList(_exclusionsKey, _exclusionsCache.toList());
  }
}
