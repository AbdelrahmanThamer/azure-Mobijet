class BatchWriteComponent {
  var ref;
  var map;

  BatchWriteComponent({
    required this.ref,
    required this.map,
  });

  Map<String, dynamic> toMap() {
    return {'ref': this.ref, 'map': this.map};
  }
}
