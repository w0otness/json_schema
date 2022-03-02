import 'package:json_schema/src/json_schema/constants.dart';
import 'package:json_schema/src/json_schema/validation_context.dart';

ValidationContext defaultRegexValidator(ValidationContext context, SchemaVersion schemaVersion, String instanceData) {
  // regex is an allowed format in draft3, out in draft4/6, back in draft7.
  // Since we don't support draft3, just draft7 is needed here.
  if (SchemaVersion.draft7 != schemaVersion) return context;
  try {
    RegExp(instanceData, unicode: true);
  } catch (e) {
    context.addError('"regex" format not accepted $instanceData');
  }
  return context;
}
