import 'package:rest_api/app/models/orderitems.dart';
import 'package:rest_api/app/models/orders.dart';
import 'package:rest_api/app/models/product.dart';
import 'package:vania/vania.dart';

class OrderitemsController extends Controller {

  Future<Response> index() async {
    // return Response.json({'message':'Hello World'});
    try {
      // Ambil data OrderItems dari database
      final items = await Orderitems().query().get();

      // Periksa jika data ditemukan
      if (items.isEmpty) {
        return Response.json({'message': 'No data found'}, 404);
      }

      // Mengembalikan data yang ditemukan
      return Response.json({'message': 'Data found', 'data': items});
    } catch (e) {
      // Menangani kesalahan yang terjadi
      return Response.json({
        'message': 'Error retrieving data',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    // return Response.json({});
    try {
      // Memeriksa apakah order_num ada di tabel Orders
      final order = await Orders().query().where('order_num', '=', request.body['order_num']).first();
      if (order == null) {
        return Response.json({'message': 'Order not found'}, 404); // Menampilkan pesan jika order tidak ditemukan
      }

      // Memeriksa apakah prod_id ada di tabel Products
      final product = await Product().query().where('prod_id', '=', request.body['prod_id']).first();
      if (product == null) {
        return Response.json({'message': 'Product not found'}, 404); // Menampilkan pesan jika produk tidak ditemukan
      }

      // Menyisipkan data ke tabel OrderItems
      await Orderitems().query().insert({
        'order_item': request.body['order_item'],
        'order_num': request.body['order_num'],
        'prod_id': request.body['prod_id'],
        'quantity': request.body['quantity'],
        'size': request.body['size'],
      });

      // Mengembalikan respon setelah data berhasil disisipkan
      return Response.json({'message': 'Data inserted'}, 201);
    } catch (e) {
      // Menangani kesalahan yang terjadi
      return Response.json({
        'message': 'Error inserting order item data',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    // return Response.json({});
    try {
      // Mencari item berdasarkan order_item
      final item = await Orderitems().query().where('order_item', '=', id).first();

      // Memeriksa apakah item ditemukan
      if (item == null) {
        return Response.json({'message': 'Data not found'}, 404); // Status 404 jika data tidak ditemukan
      }

      // Melakukan update jika data ditemukan
      await Orderitems().query().where('order_item', '=', id).update({
        'order_num': request.body['order_num'],
        'prod_id': request.body['prod_id'],
        'quantity': request.body['quantity'],
        'size': request.body['size'],
      });

      return Response.json({'message': 'Data updated'}, 200);
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error updating data', 'error': e.toString()}, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      // Mencari item yang akan dihapus
      final item = await Orderitems().query().where('order_item', '=', id).first();

      // Memeriksa apakah item ditemukan
      if (item == null) {
        return Response.json({'message': 'Data not found'}, 404); // Status 404 jika data tidak ditemukan
      }

      // Melakukan delete jika data ditemukan
      await Orderitems().query().where('order_item', '=', id).delete();

      return Response.json({'message': 'Data deleted'}, 200);
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error deleting data', 'error': e.toString()}, 500);
    }
  }
}

final OrderitemsController orderitemsController = OrderitemsController();

