// Copyright 2013-2022 Workiva Inc.
//
// Licensed under the Boost Software License (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.boost.org/LICENSE_1_0.txt
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// This software or document includes material copied from or derived
// from JSON-Schema-Test-Suite (https://github.com/json-schema-org/JSON-Schema-Test-Suite),
// Copyright (c) 2012 Julian Berman, which is licensed under the following terms:
//
//     Copyright (c) 2012 Julian Berman
//
//     Permission is hereby granted, free of charge, to any person obtaining a copy
//     of this software and associated documentation files (the "Software"), to deal
//     in the Software without restriction, including without limitation the rights
//     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//     copies of the Software, and to permit persons to whom the Software is
//     furnished to do so, subject to the following conditions:
//
//     The above copyright notice and this permission notice shall be included in
//     all copies or substantial portions of the Software.
//
//     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//     THE SOFTWARE.

import 'package:json_schema/json_schema.dart';

/// Use to register a custom vocabulary with the [JsonSchema] compiler.
///
class CustomVocabulary {
  CustomVocabulary(this._vocab, this._keywordImplementations);

  Uri _vocab;
  Map<String, CustomKeywordImplementation> _keywordImplementations;

  /// Name of the vocabulary.
  Uri get vocab => _vocab;

  /// A map of the keywords and implementation for the keywords.
  Map<String, CustomKeywordImplementation> get keywordImplementations => _keywordImplementations;
}

/// A class to contain the set of functions for setting and validating keywords in a custom vocabulary.
///
/// The two functions provided are used to process an attribute in a schema and then validate data.
///
/// The setter function takes the current JsonSchema node being processed and the data from the json.
/// The given function should validate and transform the data however is needed for the corresponding validation
/// function. If the data is bad a [FormatException] with a clear message should be thrown.
///
/// The validation function takes the output from the property setter and data from a JSON payload to be validated.
/// A [CustomValidationResult] should be returned to indicate the outcome of the validation.
class CustomKeywordImplementation {
  CustomKeywordImplementation(this._propertySetter, this._validator);

  Object Function(JsonSchema schema, Object value) _propertySetter;
  CustomValidationResult Function(Object schemaProperty, Object instanceData) _validator;

  /// Function used to set a property from the a schema.
  Object Function(JsonSchema schema, Object value) get propertySetter => this._propertySetter;

  /// Function used to validate a json value.
  CustomValidationResult Function(Object schemaProperty, Object instanceData) get validator => this._validator;
}

enum _ValidationState { valid, warning, error }

/// Result object for a custom Validation function.
/// The result can be valid, warning, or error.
/// A valid result means the data passed validation.
/// A warning means the data passed validations,
/// but with a warning. A message should be provided
/// to give the user additional information.
/// An errors means that validation failed. A message
/// should be returned explaining why validation failed.
class CustomValidationResult {
  /// Use to return a successful validation.
  CustomValidationResult.valid() {
    this._state = _ValidationState.valid;
  }

  /// Used to return a warning from a custom validator.
  CustomValidationResult.warning(String message) {
    this._state = _ValidationState.warning;
    this._message = message;
  }

  /// Used to return an error from a custom validator.
  CustomValidationResult.error(String message) {
    this._state = _ValidationState.error;
    this._message = message;
  }

  _ValidationState _state;
  String _message = "";

  /// Returns true when the result passes.
  bool get valid => _state == _ValidationState.valid;

  /// Returns true when in an error state.
  bool get error => _state == _ValidationState.error;

  /// Returns true when in a warning state.
  bool get warning => _state == _ValidationState.warning;

  /// Custom message for errors and warnings.
  String get message => _message;
}