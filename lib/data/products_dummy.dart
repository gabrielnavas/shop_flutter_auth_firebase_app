import 'package:faker/faker.dart';
import 'package:shop_flutter_app/models/product.dart';

final List<String> _names = [
  'Electronic',
  'Clothing',
  'Home',
  'Beauty Care',
  'Books',
  'Sports',
  'Toys',
  'Automotive',
  'Health',
  'Appliance',
  'Jewelry',
  'Pet Supplie',
  'Office Supplie',
  'Food',
  'Baby',
  'Garden',
  'Arts',
  'Movies',
  'Music',
  'Computers',
];

final List<Product> productsDummy = List.generate(
  _names.length,
  (index) {
    final int index = random.integer(_names.length);
    final String nameSelected = _names[index];
    final String name =
        nameSelected[0].toUpperCase() + nameSelected.substring(1);
    final Product product = Product(
      id: index.toString(),
      name: name,
      description: faker.lorem.sentence(),
      price: faker.randomGenerator.decimal(scale: 2, min: 100.0) * 10,
      imageUrl: faker.image.image(random: true, keywords: [..._names]),
    );
    return product;
  },
).toList();
