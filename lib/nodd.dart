import "package:nyxx/nyxx.dart";
import "dart:io" show Platform,exit,sleep;

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
