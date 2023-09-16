class InventoryItem {
  final String id;
  final String name;
  final String type;
  final int quantity;
  final DateTime dateAdded;
  final String imageURL;

  InventoryItem({
    required this.id,
    required this.name,
    required this.type,
    required this.quantity,
    required this.dateAdded,
    required this.imageURL,
  });
}
