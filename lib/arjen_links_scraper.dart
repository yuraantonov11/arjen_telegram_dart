import 'dart:convert';

import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';



Future getAvailability({uri = 'https://arjen.com.ua/koftu/5566/'}) async {
  var client = Client();
  // Make API call to Hackernews homepage
//  Response response = await client.get('https://arjen.com.ua/koftu/6464/');
  Response response = await client.get(uri);

  if (response.statusCode != 200) return response.body;

  // Use html parser
  var document = parse(response.body);
  List<Element> colorsEl = document.querySelectorAll('div#select_r_list > div.r_wrap');
  List<Map<String, dynamic>> sizesMap = [];

  for (var colorEl in colorsEl) {
    List<Element> sizes = colorEl.querySelectorAll('div.razmer');

    for (var size in sizes) {
      var sizeName = size.querySelector('div.r_left > span.r_left0 > span.r_left1');
      var status = size.querySelector('div.r_center > span');
      sizesMap.add({
        'title': sizeName.text,
        'status': status.text.trim(),
        'color': colorEl.attributes['data-color']
      });
    }
  }

  return json.encode(sizesMap);
}
