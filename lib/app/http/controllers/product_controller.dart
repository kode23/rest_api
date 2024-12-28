import 'package:rest_api/app/models/product.dart';
import 'package:rest_api/app/models/vendors.dart';
import 'package:vania/vania.dart';

class ProductController extends Controller {

  Future<Response> index() async {
    final products = await Product().query().get();
    return Response.json({'message': 'Data found', 'data': products});
  }

  Future<Response> store(Request request) async {
    // check if vend_id exists
    final vendor = await Vendors()
        .query()
        .where('vend_id', '=', request.body['vend_id'])
        .first();
    if (vendor == null) {
      return Response.json({'message': 'Vendor not found'});
    }

    await Product().query().insert({
      'prod_id': request.body['prod_id'],
      'vend_id': request.body['vend_id'],
      'prod_name': request.body['prod_name'],
      'prod_price': request.body['prod_price'],
      'prod_desc': request.body['prod_desc'],
    });

    return Response.json({'message': 'Data inserted', 'data': vendor});
  }

  Future<Response> show(String id) async {
    final product = await Product().query().where('prod_id', '=', id).first();

    if (product == null) {
      return Response.json({'message': 'Data not found'});
    }

    return Response.json({'message': 'Data found', 'data': product});
  }

  Future<Response> update(Request request, String id) async {
    try {
      // Memeriksa apakah produk ada
      final product = await Product().query().where('prod_id', '=', id).first();
    
      if (product == null) {
        return Response.json({'message': 'Data not found'}, 404);
      }

      // Validasi input
      if (request.body['prod_name'] == null || request.body['prod_name'].isEmpty) {
        return Response.json({'message': 'Product name is required'}, 400);
      }

      // Update produk
      final updateResult = await Product().query().where('prod_id', '=', id).update({
        'vend_id': request.body['vend_id'],
        'prod_name': request.body['prod_name'],
        'prod_price': request.body['prod_price'],
        'prod_desc': request.body['prod_desc'],
      });

      if (updateResult == 0) {
        return Response.json({'message': 'No data updated'}, 404);
      } 

      // Return response success
      return Response.json({'message': 'Data updated'}, 200);
    } catch (e) {
      // Tangani kesalahan tak terduga
      return Response.json({
        'message': 'Terjadi kesalahan pada server',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> destroy(int id) async {
    await Product().query().where('prod_id', '=', id).delete();

    return Response.json({'message': 'Data deleted'});
  }
}

final ProductController productController = ProductController();

