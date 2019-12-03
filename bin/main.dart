import 'dart:io' show Platform, HttpClient;
// import 'dart:io' as io;
import 'package:dart_server/people_controller.dart';
import 'package:mongo_dart/mongo_dart.dart';

import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:teledart/model.dart';

import 'package:dart_server/models/user_model.dart';
import 'package:dart_server/arjen_links_scraper.dart' as arjen_links_scraper;


void main() async {
  print('PORT');
  Db db = Db("mongodb://yuraantonov11:r8DoC6ohdJds@ds151973.mlab.com:51973/arjen_tg_dart");

  await db.open();

  var Users = PeopleController(db);

  print('Connected to database');

  final Map<String, String> envVars = Platform.environment;
  print(envVars);

  TeleDart teledart = TeleDart(Telegram('1002046907:AAHvjYyV6NOI293XHID7NsyC9IaDKA0jqA4'), Event());

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
      .onCommand('start')
      .listen(( (message) async {
        User user = User.fromJson({'id': 1});

//        print(await Users.getUser(message.from.id));

//        FIXME: Convert message.from to map of strings
//        var userData = message.from;
        var userData = {"_id": 123};

//        print(await Users.createUser(user));
//        print(await Users.getUser(123));
    return teledart.replyMessage(message, 'Started');
  }));

  // Or using short cuts
  teledart
      .onCommand('get')
      .listen(( (message) async {
        var arr = message.text.split(' ');
        if(arr.length<2){
          return teledart.replyMessage(message, 'Url is not valid');
        }
        var link = message.text.split(' ')[1];
        bool _validURL = Uri.parse(link).isAbsolute;
        if(!_validURL){
          return teledart.replyMessage(message, 'Url is not valid');
        }

        var itemStatus = await arjen_links_scraper.getAvailability(link);

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
