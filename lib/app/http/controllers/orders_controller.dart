import 'package:rest_api/app/models/customers.dart';
import 'package:rest_api/app/models/orders.dart';
import 'package:vania/vania.dart';

class OrdersController extends Controller {

    Future<Response> index() async {
      try {
      // Mengambil data orders beserta relasi dari tabel lain
      final orders = await Orders().query()
        .join('customers', 'customers.cust_id', '=', 'orders.cust_id')
        .join('orderitems', 'orderitems.order_num', '=', 'orders.order_num')
        .join('product', 'product.prod_id', '=', 'orderitems.prod_id')
        .join('productnotes', 'productnotes.prod_id', '=', 'product.prod_id')
        .select([
          'orders.order_num',
          'orders.order_date',
          'customers.cust_name',
          'orderitems.order_item',
          'product.prod_name',
          'productnotes.note_text',
        ]).get();

        // 'orders.order_num', 'orders.order_date', // Pilih kolom dari tabel orders
      // 'customers.cust_name', 'customers.cust_id', // Pilih kolom dari tabel customers
      // 'orderitems.quantity', 'orderitems.price', // Pilih kolom dari tabel orderitems
      // 'products.prod_name', 'products.prod_id', // Pilih kolom dari tabel products
      // 'productnotes.note' // Pilih kolom dari tabel productnotes

      // Mengembalikan respons JSON dengan data yang ditemukan
      return Response.json({
        'message': 'Data found',
        'data': orders,
      });
    } catch (e) {
      // Menangani kesalahan dan mengembalikan pesan error
      return Response.json({
        'message': 'Error fetching order data',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      // Cek apakah customer dengan cust_id yang diberikan ada
      final customer = await Customers().query().where('cust_id', '=', request.body['cust_id']).first();

      // Jika customer tidak ditemukan, kembalikan respons dengan pesan error
      if (customer == null) {return Response.json({'message': 'Customer tidak ditemukan'}, 404);}

      // Menyimpan data order jika customer ditemukan
      await Orders().query().insert({
        'order_num': request.body['order_num'],
        'cust_id': request.body['cust_id'],
        'order_date': request.body['order_date'],
      });

      // Mengembalikan respons setelah data berhasil dimasukkan
      return Response.json({
        'message': 'Order berhasil',
        'order_num': request.body['order_num'],
        'cust_id': request.body['cust_id'],
        'order_date': request.body['order_date'],
      });
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error inserting order data', 'error': e.toString()}, 500);
    }
  }

     Future<Response> show(int id) async {
          return Response.json({});
     }

     Future<Response> edit(int id) async {
          return Response.json({});
     }

     Future<Response> update(Request request,int id) async {
          return Response.json({});
     }

     Future<Response> destroy(int id) async {
          return Response.json({});
     }
}

final OrdersController ordersController = OrdersController();

