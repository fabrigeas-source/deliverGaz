import 'dart:convert';
import 'dart:io';

/// Fills missing translation keys in ARB files using English strings as placeholders
/// with a trailing marker " [TODO: translate]".
///
/// - Reads template from lib/l10n/app_en.arb
/// - Updates lib/l10n/app_es.arb and lib/l10n/app_fr.arb
/// - Uses build/l10n_untranslated.json if present to target only missing keys
/// - Preserves existing translations, and only adds keys not present
Future<void> main(List<String> args) async {
  final l10nDir = Directory('lib/l10n');
  final reportFile = File('build/l10n_untranslated.json');

  if (!l10nDir.existsSync()) {
    stderr.writeln('lib/l10n directory not found. Run from project root.');
    exitCode = 1;
    return;
  }

  final templatePath = 'lib/l10n/app_en.arb';
  final esPath = 'lib/l10n/app_es.arb';
  final frPath = 'lib/l10n/app_fr.arb';

  Map<String, dynamic> loadJson(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      stderr.writeln('File not found: $path');
      exitCode = 1;
      throw Exception('Missing file: $path');
    }
    return json.decode(file.readAsStringSync()) as Map<String, dynamic>;
  }

  void saveJson(String path, Map<String, dynamic> data) {
    // Sort keys for stability (non-spec, but improves diffs)
    final sortedKeys = data.keys.toList()..sort();
    final sortedMap = { for (final k in sortedKeys) k : data[k] };
    final encoder = const JsonEncoder.withIndent('  ');
    File(path).writeAsStringSync('${encoder.convert(sortedMap)}\n');
  }

  String placeholderValue(String english) => '$english [TODO: translate]';

  final en = loadJson(templatePath);
  final es = loadJson(esPath);
  final fr = loadJson(frPath);

  // Decide which keys to fill based on report if available, else by comparing maps
  Set<String> keysToFill(String locale, Map<String, dynamic> target) {
    final allKeys = en.keys.where((k) => !k.startsWith('@')).toSet();
    final existing = target.keys.where((k) => !k.startsWith('@')).toSet();
    final missing = allKeys.difference(existing);

    if (reportFile.existsSync()) {
      final report = json.decode(reportFile.readAsStringSync()) as Map<String, dynamic>;
      final listed = (report[locale] as List?)?.cast<String>().toSet() ?? <String>{};
      // Intersect to be safe
      return missing.intersection(listed.isEmpty ? missing : listed);
    }
    return missing;
  }

  int addedEs = 0, addedFr = 0;
  for (final key in keysToFill('es', es)) {
    final value = en[key];
    if (value is String) {
      es[key] = placeholderValue(value);
      addedEs++;
    }
  }
  for (final key in keysToFill('fr', fr)) {
    final value = en[key];
    if (value is String) {
      fr[key] = placeholderValue(value);
      addedFr++;
    }
  }

  saveJson(esPath, es);
  saveJson(frPath, fr);

  stdout.writeln('Filled missing translations: es=$addedEs, fr=$addedFr');
  stdout.writeln('Updated files: $esPath, $frPath');
}
