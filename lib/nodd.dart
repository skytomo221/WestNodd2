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
    ..syncOnReady();
  final prefixes = {
    "sl": "/",
    "ps": "%",
    "dl": "\$",
  };
  final prefix = prefixes["sl"];
  if (prefix == null) {
    throw Error();
  }
  bot.onReady.listen((ReadyEvent e) {
    print("Ready!");
  });
  bot.onMessageReceived.listen((event) {
    String command_this = event.message.content.substring(prefix.length);
    String prefix_this = event.message.content.substring(0, 1);
    if (prefix_this == prefix) {
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
    } else {}
    print(event.message.content);
  });
}
