import 'dart:io' show Platform, HttpClient;
// import 'dart:io' as io;

import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/model.dart';

import 'package:dart_server/arjen_links_scraper.dart' as arjen_links_scraper;


void main() async{
  print(await arjen_links_scraper.getAvailability(uri: 'https://arjen.com.ua/koftu/6464/'));

  final Map<String, String> envVars = Platform.environment;

  TeleDart teledart = TeleDart(Telegram(envVars['BOT_TOKEN']), Event());

  // TeleDart uses longpull by default.
  teledart.start().then((me) => print('${me.username} is initialised'));

  // In case you decided to use webhook.
  // teledart.setupWebhook(envVars['HOST_URL'], envVars['BOT_TOKEN'],
  //     io.File(envVars['CERT_PATH']), io.File(envVars['KEY_PATH']),
  //     port: int.parse(envVars['BOT_PORT']));
  // teledart
  //     .start(webhook: true)
  //     .then((me) => print('${me.username} is initialised'));

  // You can listen to messages like this
//  teledart.onMessage(entityType: 'bot_command', keyword: 'start').listen(
//          (message) =>
//          teledart.telegram.sendMessage(message.chat.id, 'Hello TeleDart!'));

  // Or using short cuts
  teledart
      .onCommand('get')
      .listen(( (message) async {
        var link = message.text.split(' ')[1];
        bool _validURL = Uri.parse(link).isAbsolute;
        if(!_validURL){
          return teledart.replyMessage(message, 'Url is not valid');
        }

        var itemStatus = await arjen_links_scraper.getAvailability(uri: link);

        return teledart.replyMessage(message, itemStatus);
      }));

  // You can even filter streams with stream processing methods
  // See: https://www.dartlang.org/tutorials/language/streams#methods-that-modify-a-stream
//  teledart
//      .onMessage(keyword: 'dart')
//      .where((message) => message.text.contains('telegram'))
//      .listen((message) => teledart.replyPhoto(
//      message,
//      //  io.File('example/dash_paper_plane.png'),
//      'https://raw.githubusercontent.com/DinoLeung/TeleDart/master/example/dash_paper_plane.png',
//      caption: 'This is how Dash found the paper plane'));
//
//  // Inline mode.
//  teledart
//      .onInlineQuery()
//      .listen((inlineQuery) => teledart.answerInlineQuery(inlineQuery, [
//    InlineQueryResultArticle()
//      ..id = 'ping'
//      ..title = 'ping'
//      ..input_message_content = (InputTextMessageContent()
//        ..message_text = '*pong*'
//        ..parse_mode = 'markdown'),
//    InlineQueryResultArticle()
//      ..id = 'ding'
//      ..title = 'ding'
//      ..input_message_content = (InputTextMessageContent()
//        ..message_text = '_dong_'
//        ..parse_mode = 'markdown')
//  ]));
}
