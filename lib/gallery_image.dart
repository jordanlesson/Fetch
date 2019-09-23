import 'dart:typed_data';

class GalleryImage {
  Uint8List bytes;
  String id;
  int dateCreated;
  String location;

  GalleryImage({this.bytes, this.id, this.dateCreated, this.location});
}
