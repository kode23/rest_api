import 'package:vania/vania.dart';

class CreateOrderitemsTable extends Migration {

  @override
  Future<void> up() async{
   super.up();
   await createTableNotExists('orderitems', () {
      integer('order_item', unique: true);
      primary('order_item');
      integer('order_num');
      foreign('order_num', 'orders', 'order_num', constrained: true, onDelete: 'CASCADE');
      string('prod_id', length: 10);
      foreign('prod_id', 'product', 'prod_id',constrained: true, onDelete: 'CASCADE');
      integer('quantity');
      integer('size');
    });
  }
  
  @override
  Future<void> down() async {
    super.down();
    await dropIfExists('orderitems');
  }
}
