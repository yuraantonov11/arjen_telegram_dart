import 'dart:io';
//import 'models/user_model.dart';

import 'package:mongo_dart/mongo_dart.dart';

import 'models/user_model.dart';

class PeopleController {
  PeopleController(Db db) : _store = db.collection('people');

  final DbCollection _store;


  getUsers() async {
    await _store.find().toList();
  }

  getUser(int id) async {
    var user = await _store.findOne(where.eq('_id', 123));
    print(user);
  }

  createUser(Object fields) async {
    await _store.save(fields);
  }

  deleteUser(int id) async {
    var itemToDelete = await _store.findOne(where.eq('_id', id));
    if (itemToDelete != null) {
      await _store.remove(itemToDelete);
    }
  }

  patchUser(int id, fields) async {
    var itemToPatch = await _store.findOne(where.eq('_id', id));
    await _store.update(itemToPatch, {r'$set': fields});
  }
}
