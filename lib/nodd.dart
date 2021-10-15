import "package:nyxx/nyxx.dart";
import "dart:io" show Platform,exit,sleep;
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

 */
void main(List<String> args) {
  Map<String, String> envVars = Platform.environment;
  Nyxx bot = Nyxx(envVars["noddbottoken"], GatewayIntents.allUnprivileged);
  String prefix= "/";
  bot.onReady.listen((ReadyEvent e) {
    print("Ready!");
    print("${envVars["noddbottoken"]}");
    print("${envVars["nodddbtoken"]}");
  });
  bot.onMessageReceived.listen((event) {
    String command_this = event.message.content;
    String prefix_this = command_this.subString(0,1);
    if (prefix_this == prefix) {
      if(command_this.startsWith("/quit")||command_this.startsWith("/exit")||command_this.startsWith("/kill")){
        event.message.channel.sendMessage(MessageBuilder.content("Nodd System Shutdown."));
        print("Nodd System Shutdown.");
        sleep(Duration(seconds: 6));
        exit(0);
      }else{
      event.message.channel.sendMessage(MessageBuilder.content("Pong: \n${command_this.substring(1)}"));
      }
    }else{
    }
    print(event.message.content);
  });
}
