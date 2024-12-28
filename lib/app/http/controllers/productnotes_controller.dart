import 'package:rest_api/app/models/product.dart';
import 'package:rest_api/app/models/productnotes.dart';
import 'package:vania/vania.dart';

class ProductnotesController extends Controller {

  Future<Response> index() async {
    try {
      // Mengambil data dari tabel ProductNotes
      final notes = await Productnotes().query().get();

      // Memeriksa apakah data ditemukan
      if (notes.isEmpty) {
        return Response.json({'message': 'No data found'}, 404); // Status 404 jika tidak ada data
      }

      // Jika data ditemukan
      return Response.json({'message': 'Data found', 'data': notes}, 200);
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({
        'message': 'Error retrieving data', 
        'error': e.toString()
      }, 500);
    }
  }

  Future<Response> store(Request request) async {
    try {
      // Validasi bahwa semua field diperlukan ada dalam request body
      final requiredFields = ['note_id', 'prod_id', 'note_date', 'note_text'];
      for (var field in requiredFields) {
        if (request.body[field] == null || request.body[field].isEmpty) {
          return Response.json({'message': '$field is required'}, 400); 
        }
      }

      // Cek apakah prod_id valid (produk ada di database)
      final product = await Product().query().where('prod_id', '=', request.body['prod_id']).first();
      if (product == null) {
        return Response.json({'message': 'Product not found'}, 404);  
      }

      // Insert data ke tabel ProductNotes
      await Productnotes().query().insert({
        'note_id': request.body['note_id'],
        'prod_id': request.body['prod_id'],
        'note_date': request.body['note_date'],
        'note_text': request.body['note_text'],
      });

      // Kembalikan response sukses jika data berhasil ditambahkan
      return Response.json({'message': 'Data inserted'}, 201);
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error inserting data', 'error': e.toString()}, 500);
    }
  }

  Future<Response> show(String id) async {
    try {
      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({'message': 'Data not found'});
      }

      // Kembalikan respons dengan data produk
      return Response.json({'message': 'Data found', 'data': product}, 200);
    } catch (e) {
      // Tangani kesalahan tak terduga
      return Response.json({
        'message': 'Terjadi kesalahan pada server',
        'error': e.toString(),
      }, 500);
    }
  }

  Future<Response> update(Request request, String id) async {
    try {
      // Periksa apakah catatan (note) dengan note_id ada
      final note = await Productnotes().query().where('note_id', '=', id).first();
      if (note == null) {
        return Response.json({'message': 'Data not found'}, 404);
      }

      // Validasi apakah prod_id ada di tabel Products
      final product = await Product().query().where('prod_id', '=', request.body['prod_id']).first();
      if (product == null) {
        return Response.json({'message': 'Product not found'}, 404);
      }

      // Lakukan pembaruan data
      await Productnotes().query().where('note_id', '=', id).update({
        'prod_id': request.body['prod_id'],
        'note_date': request.body['note_date'],
        'note_text': request.body['note_text'],
      });

      return Response.json({'message': 'Data updated'}, 200);
    } catch (e) {
      // Tangani kesalahan tak terduga
      return Response.json({
        'message': 'Terjadi kesalahan pada server',
        'error': e.toString(),
      }, 500);
    }
  } 

  Future<Response> destroy(String id) async {
    try {
      // Periksa apakah produk ada sebelum menghapusnya
      final product = await Product().query().where('prod_id', '=', id).first();

      if (product == null) {
        return Response.json({'message': 'Data not found'}, 404);
      }

      // Hapus produk dari database
      await Product().query().where('prod_id', '=', id).delete();

      return Response.json({'message': 'Data deleted successfully'}, 200);
    } catch (e) {
      // Tangani kesalahan tak terduga
      return Response.json({
        'message': 'Terjadi kesalahan pada server',
        'error': e.toString(),
      }, 500);
    }
  }
}

final ProductnotesController productnotesController = ProductnotesController();

