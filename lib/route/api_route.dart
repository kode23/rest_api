import 'package:rest_api/app/http/controllers/customers_controller.dart';
import 'package:rest_api/app/http/controllers/orderitems_controller.dart';
import 'package:rest_api/app/http/controllers/orders_controller.dart';
import 'package:rest_api/app/http/controllers/product_controller.dart';
import 'package:rest_api/app/http/controllers/productnotes_controller.dart';
import 'package:rest_api/app/http/controllers/vendors_controller.dart';
import 'package:vania/vania.dart';

class ApiRoute implements Route {
  @override
  void register() {
    // Router.basePrefix('api');

    // Customers
    Router.get('/customer', customersController.index);
    Router.post('/customer', customersController.store);
    Router.get('/customer/{id}', customersController.show);
    Router.put('/customer/{id}', customersController.update);
    Router.delete('/customer/{id}', customersController.destroy);

    // Vendors
    Router.post('/vendor', vendorsController.store);
    Router.get('/vendor', vendorsController.index);
    Router.get('/vendor/{id}', vendorsController.show);
    Router.put('/vendor/{id}', vendorsController.update);
    Router.delete('/vendor/{id}', vendorsController.destroy);

    // Orders
    Router.post('/order', ordersController.store);
    Router.get('/order', ordersController.index);

    // Product
    Router.post('/product', productController.store);
    Router.get('/product', productController.index);
    Router.get('/product', productController.show);
    Router.put('/product/{id}', productController.update);
    Router.delete('/product/{id}', productController.destroy);

    // order Items
    Router.get('/orderitems', orderitemsController.index);
    Router.post('/orderitems', orderitemsController.store);
    Router.put('/orderitems/{id}', orderitemsController.update);
    Router.delete('/orderitems/{id}', orderitemsController.destroy);

    // Product Notes
    Router.get('/productnote', productnotesController.index);
    Router.get('/productnote', productnotesController.show);
    Router.post('/productnote', productnotesController.store);
    Router.put('/productnote', productnotesController.update);
    Router.delete('/productnote', productnotesController.destroy);
  }
}
