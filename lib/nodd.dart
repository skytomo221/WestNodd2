import "package:nyxx/nyxx.dart";
import "dart:io" show Platform, exit, sleep;

import 'package:nyxx_interactions/interactions.dart';

/**
方針：コマンドは推論型付きマクロ言語となるように構成したい(理想/できれば)
"@"　型注釈
":"　コマンド合成/プロパティ接続
"|"　並列実行
"+>"　逐次実行
"?"　nullable　T? = maybe[T] = or[T,null]
">"　右代入
"<"　左代入
"(" ")"　コマンドブロック

型関係：
anything
object << anything, null << anything
number << object,{x@number, y@number}:bind>frac << object,bool << object,string << object,regexp << object,
domain << object,path << object,uri << object,url << uri,
userid << object, twitterid << userid,discordid << userid,channelid << object,guilid << object,massageid << object,

ジェネリクス型：
or[T,U],iterator[T],iterator[K,V],result[R,E],maybe[T]

bind：
{el1,el2,el3}:bind>some
some:unbind>{el1,el2,el3}

詳細は ../docs/spec/lang.md

 */
void main(List<String> args) {
  final envVars = Platform.environment;
  final token = envVars["DISCORD_NODD_BOT_TOKEN"];
  if (token == null) {
    throw Exception(
        "Token is not difined. Please set `export DISCORD_NODD_BOT_TOKEN=<TOKEN>`");
  }
  final guildId = envVars["DISCORD_NODD_GUILD_ID"];
  if (guildId == null) {
    throw Exception(
        "Guild ID is not difined. Please set `export DISCORD_NODD_GUILD_ID=<GUILD ID>`");
  }
  Nyxx bot = Nyxx(token, GatewayIntents.allUnprivileged);
  Interactions(bot)
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
          final text = event.getArg("text").value.toString();
          final catText = text.replaceAll("な", "にゃ");
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
            CommandOptionType.string,
            "raw_nick",
            "新しいニックネーム",
          ),
        ],
        guild: guildId.toSnowflake())
      ..registerHandler((event) async {
        final rawNick = event.getArg("raw_nick").value.toString();
        if (RegExp(r'（Ｎｏ．[０-９]+）').hasMatch(rawNick)) {
          event.respond(MessageBuilder.content("そのニックネームには変更できません。"));
        } else {
          final author = event.interaction.memberAuthor!;
          final scjId =
              RegExp(r'（Ｎｏ．[０-９]+）$').firstMatch(author.nickname!)!.group(0)!;
          final newNick = rawNick + scjId;
          await author.edit(nick: newNick);
          event.respond(MessageBuilder.content("あなたのニックネームを $newNick に変更しました"));
        }
      }))
    ..syncOnReady();
  final Map<String,String> prefixes = {
    "sl": "/",
    "ps": "%",
    "dl": "\$",
  };
  final String prefix = prefixes["ps"]!;

  bot.onReady.listen((ReadyEvent e) {
    print("Ready!");
  });
  bot.onMessageReceived.listen((event) {
    String command_this = event.message.content.substring(prefix.length);
    String prefix_this = event.message.content.substring(0, prefix.length);
    if (prefix_this == prefix) {
      // コマンド実行(スラッシュコマンド以外)
      if (command_this.startsWith("quit") ||
          command_this.startsWith("exit") ||
          command_this.startsWith("kill")) {
        event.message.channel
            .sendMessage(MessageBuilder.content("Nodd System Shutdown."));
        print("Nodd System Shutdown.");
        sleep(Duration(seconds: 6));
        exit(0);
      } else {
        event.message.channel
            .sendMessage(MessageBuilder.content("Pong: \n${command_this}"));
      }
    } else {
      //コマンド以外のメッセージ
    }
    print(event.message.content);
  });
}
