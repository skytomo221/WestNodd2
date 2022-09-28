// ignore_for_file: unused_local_variable, unnecessary_brace_in_string_interps, prefer_const_declarations, avoid_print, avoid_shadowing_type_parameters, slash_for_doc_comments
// ignore: todo
// TODO: Delete ignore_for_file

import 'package:nodd/number_manager.dart';
import "package:nyxx/nyxx.dart";
import "dart:io" show Platform, exit, sleep;

import 'package:nyxx_interactions/nyxx_interactions.dart';

void main(List<String> args) {
  final scjNumberFormat = RegExp(r'#\d{4}$');
  final Map<String, String> envVars = Platform.environment;
  final String? token = envVars["DISCORD_NODD_BOT_TOKEN"];
  if (token == null) {
    throw Exception(
        "Token is not defined. Please set `export DISCORD_NODD_BOT_TOKEN=<TOKEN>`");
  }
  final String? guildId = envVars["DISCORD_NODD_GUILD_ID"];
  if (guildId == null) {
    throw Exception(
        "Guild ID is not defined. Please set `export DISCORD_NODD_GUILD_ID=<GUILD ID>`");
  }
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
  final String? clientId = envVars["DISCORD_NODD_CLIENT_ID"];
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
  final bot =
      NyxxFactory.createNyxxWebsocket(token, GatewayIntents.allUnprivileged)
        ..registerPlugin(Logging()) // Default logging plugin
        ..registerPlugin(
            CliIntegration()) // Cli integration for nyxx allows stopping application via SIGTERM and SIGKILl
        ..registerPlugin(
            IgnoreExceptions()) // Plugin that handles uncaught exceptions that may occur
        ..connect();
  IInteractions.create(WebsocketInteractionBackend(bot))
    ..registerSlashCommand(SlashCommandBuilder(
        "neko",
        "Noddくんが生きているか判定します。",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "text", "Noddくんに言わせるセリフ",
              required: false),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) {
        if (event.args.any((element) => element.name == "text")) {
          final String text = event.getArg("text").value.toString();
          final String catText = text.replaceAll("な", "にゃ");
          event.respond(MessageBuilder.content("${catText}にゃ"));
        } else {
          event.respond(MessageBuilder.content("にゃーん"));
        }
      }))
    ..registerSlashCommand(SlashCommandBuilder(
        "nick",
        "ニックネームを変更します。",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "raw_nick", "新しいニックネーム",
              required: true),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) async {
        final rawNick = event.getArg("raw_nick").value.toString();
        if (rawNick.length > 27) {
          event.respond(MessageBuilder.content(
              "入力した文字列の長さは ${rawNick.length} ですが、ニックネームの最大文字数は27文字です。"));
          return;
        }

        final IMember author = event.interaction.memberAuthor!;
        final match = scjNumberFormat.firstMatch(author.nickname!);
        final String scjId = (match == null)
            ? '#${(await numberManager.register(event.interaction.memberAuthor!.id.id))}'
            : match.group(0)!;
        final String newNick = rawNick + scjId;
        await author.edit(builder: MemberBuilder()..nick = newNick);
        event.respond(MessageBuilder.content("あなたのニックネームを $newNick に変更しました"));
      }))
    ..registerSlashCommand(SlashCommandBuilder(
        "number",
        "SCJナンバーが登録されていなければ登録します。",
        [
          CommandOptionBuilder(
              CommandOptionType.string, "user_id", "対象のユーザーのID",
              required: true),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) async {
        final userId = event.getArg("user_id").value.toString();
        final guild = await event.interaction.guild?.getOrDownload();
        final member = await guild?.fetchMember(Snowflake(userId));
        if (member == null) {
          event.respond(MessageBuilder.content("そのIDに対応するメンバーは見つかりませんでした"));
          return;
        }
        final user = await member.user.getOrDownload();
        if (user.bot) return;
        final nickname =
            (member.nickname ?? user.username).replaceAll(scjNumberFormat, '');
        final match = scjNumberFormat.firstMatch(nickname);
        final String scjId = (match == null)
            ? '#${(await numberManager.register(member.id.id))}'
            : match.group(0)!;
        final String newNick = nickname + scjId;
        await member.edit(builder: MemberBuilder()..nick = newNick);
        event.respond(MessageBuilder.content("$nickname さんを $newNick に変更しました"));
      }))
    ..syncOnReady();

  final Map<String, String> prefixes = {
    "sl": "/",
    "ps": "%",
    "dl": "\$",
  };
  final String prefixKey = "ps";
  final String prefix =
      prefixes.containsKey(prefixKey) ? prefixes[prefixKey]! : "";

  bot.onReady.listen((ReadyEvent e) {
    print("Ready!");
  });
  bot.onMessageReceived.listen((MessageReceivedEvent event) {
    String commandThis = event.message.content.substring(prefix.length);
    String prefixThis = event.message.content.substring(0, prefix.length);
    if (prefixThis == prefix) {
      // コマンド実行(スラッシュコマンド以外)
      if (commandThis.startsWith("quit") ||
          commandThis.startsWith("exit") ||
          commandThis.startsWith("kill")) {
        IMessageAuthor at = event.message.author;
        String tag = at.tag;
        if (tag == "thd：佐藤陽花#7369" || tag == "skytomo#9913") {
          event.message.channel
              .sendMessage(MessageBuilder.content("Nodd System Shutdown."));
          print("Nodd System Shutdown.");
          sleep(const Duration(seconds: 6));
          exit(0);
        } else {
          event.message.channel.sendMessage(
              MessageBuilder.content("Noddシステムをシャットダウンする権限がありません。"));
        }
      } else {
        event.message.channel
            .sendMessage(MessageBuilder.content("Pong: \n$commandThis"));
      }
    } else {
      //コマンド以外のメッセージ
    }
    print(event.message.content);
  });
}

extension IndexedMap<T, E> on List<T> {
  List<E> indexedMap<E>(E Function(int index, T item) function) {
    final list = <E>[];
    asMap().forEach((index, element) {
      list.add(function(index, element));
    });
    return list;
  }
}
