import 'package:vania/vania.dart';

class CreateProductTable extends Migration {
  @override
  Future<void> up() async {
    super.up();
    await createTableNotExists('product', () {
      string('prod_id', length: 10, unique: true);
      primary('prod_id');
      char('vend_id', length: 5);
      foreign('vend_id', 'vendors', 'vend_id', constrained: true, onDelete: 'CASCADE');
      string('prod_name', length: 25);
      integer('prod_price');
      text('prod_desc');
    });
  }

  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('product');
  }
}
