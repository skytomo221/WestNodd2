@Tags(['gsheets'])
import 'dart:io';

import 'package:nodd/number_manager.dart';
import 'package:nodd/scj_number.dart';
import 'package:test/test.dart';

void main() {
  final Map<String, String> envVars = Platform.environment;
  final String? projectId = envVars["DISCORD_NODD_PROJECT_ID"];
  if (projectId == null) {
    throw Exception(
        "Project ID is not defined. Please set `export DISCORD_NODD_PROJECT_ID=<PROJECT ID>`");
  }
  final String? privateKeyId = envVars["DISCORD_NODD_PRIVATE_KEY_ID"];
  if (privateKeyId == null) {
    throw Exception(
        "Private key ID is not defined. Please set `export DISCORD_NODD_PRIVATE_KEY_ID=<PRIVATE KEY ID>`");
  }
  final String? privateKey = envVars["DISCORD_NODD_PRIVATE_KEY"];
  if (privateKey == null) {
    throw Exception(
        "Private key is not defined. Please set `export DISCORD_NODD_PRIVATE_KEY=<PRIVATE KEY>`");
  }
  final String? clientEmail = envVars["DISCORD_NODD_CLIENT_EMAIL"];
  if (clientEmail == null) {
    throw Exception(
        "Client E-mail is not defined. Please set `export DISCORD_NODD_CLIENT_EMAIL=<CLIENT EMAIL>`");
  }
  final String? clientId = envVars["DISCORD_NODD_CLIENT_EMAIL"];
  if (clientId == null) {
    throw Exception(
        "Client ID is not defined. Please set `export DISCORD_NODD_CLIENT_ID=<CLIENT ID>`");
  }
  final String? clientX509CertUrl =
      envVars["DISCORD_NODD_CLIENT_X509_CERT_URL"];
  if (clientX509CertUrl == null) {
    throw Exception(
        "The URL of the public x509 certificate is not defined. Please set `export DISCORD_NODD_CLIENT_X509_CERT_URL=<CLIENT X509 CERT URL>`");
  }
  final String? spreadsheetId = envVars["DISCORD_NODD_SPREADSHEET_ID"];
  if (spreadsheetId == null) {
    throw Exception(
        "Spreadsheet ID is not defined. Please set `export DISCORD_NODD_SPREADSHEET_ID=<SPREADSHEET ID>`");
  }
  final credentials = '''
{
  "type": "service_account",
  "project_id": "$projectId",
  "private_key_id": "$privateKeyId",
  "private_key": "$privateKey",
  "client_email": "$clientEmail",
  "client_id": "$clientId",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "$clientX509CertUrl"
}
''';
  final numberManager = NumberManager(credentials, spreadsheetId);

  test('NumberManager test', () async {
    expect(await numberManager.assigned(0), false);
    expect(await numberManager.registered(0), false);
    expect(await numberManager.assigned(0), false);
    await numberManager.register(0);
    expect(await numberManager.registered(0), true);
    expect(await numberManager.assigned(scjNumber(0)), true);
    // Duplicate test
    expect(scjNumber(6205), scjNumber(0));
    expect(await numberManager.registered(6205), false);
    expect(await numberManager.assigned(scjNumber(6205)), true);
    await numberManager.register(6205);
    expect(await numberManager.assigned(scjNumber(6206)), true);
    print("[Important] Delete a row which user ID is 0 and 414!");
  });
}
