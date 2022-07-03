import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService{
  static final _storageRef = FirebaseStorage.instance.ref();
  static const _uuid = Uuid();

  static Future<String> _uploadFile(File file)async{
    var result = "";
    var extension = path.extension(file.path);
    final fileRef = _storageRef.child("images/${_uuid.v1()}$extension");
    final uploadTask = fileRef.putFile(file);
    await uploadTask.whenComplete(()async{
      result = await fileRef.getDownloadURL();
    });
    return result;
  }

  static Future<String> uploadFile(XFile file)async{
    return await _uploadFile(File(file.path));
  }

  static Future<List<String>> uploadFiles(List<XFile> files)async{
    List<String> list = [];
    for(XFile file in files){
      list.add(await _uploadFile(File(file.path)));
    }
    return list;
  }

}