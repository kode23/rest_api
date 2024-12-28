import 'package:rest_api/app/models/customers.dart';
import 'package:vania/vania.dart';

class CustomersController extends Controller {
  Future<Response> index() async {
    final customers = await Customers().query().get();

    if (customers.isEmpty) {
      return Response.json({
        'message': 'Data tidak ditemukan',
      }, 404); // Menggunakan status code 404 untuk "Not Found"
    }

    return Response.json({
      'message': 'Data customers',
      'data': customers,
    });
  }

  Future<Response> store(Request request) async {
    try {
      // Validasi input
      if (request.body['cust_id'] == null || request.body['cust_id'].isEmpty) {
        return Response.json({'message': 'cust_id harus diisi'}, 400);
      }

      if (request.body['cust_name'] == null || request.body['cust_name'].isEmpty) {
        return Response.json({'message': 'cust_name harus diisi'}, 400);
      }

      // Cek apakah cust_id sudah ada
      final existingCustomer = await Customers().query().where('cust_id', '=', request.body['cust_id']).first();

      if (existingCustomer != null) {
        return Response.json({'message': 'cust_id sudah ada'}, 409); // Response jika cust_id sudah ada
      }

      // Menyimpan data ke dalam database
      await Customers().query().insert({
        'cust_id': request.body['cust_id'],
        'cust_name': request.body['cust_name'],
        'cust_address': request.body['cust_address'],
        'cust_city': request.body['cust_city'],
        'cust_state': request.body['cust_state'],
        'cust_zip': request.body['cust_zip'],
        'cust_country': request.body['cust_country'],
        'cust_telp': request.body['cust_telp'],
      });

      // Ambil kembali data customer yang baru dimasukkan
      final newCust = await Customers().query().where('cust_id', '=', request.body['cust_id']).first();

      return Response.json({'message': 'Berhasil menambahkan data', 'data': newCust}, 201);
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error inserting data', 'error': e.toString()}, 500);
    }
  }

  Future<Response> show(int id) async {
    try {
      final cust = await Customers().query().where('cust_id', '=', id).first();

      if (cust == null) {
        // Jika data tidak ditemukan
        return Response.json({'message': 'Data customer $id tidak ditemukan'}, 404);
      }

      // Jika data ditemukan, kirimkan respons dengan status 200
      return Response.json({'message': 'Data customer', 'data': cust}, 200);
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error occurred', 'error': e.toString()}, 500);
    }
  }

  Future<Response> update(Request request, int id) async {
    try {
      // Cek apakah customer dengan cust_id yang diberikan ada
      final customer = await Customers().query().where('cust_id', '=', id).first();

      if (customer == null) {
        // Jika customer tidak ditemukan
        return Response.json({'message': 'Customer $id tidak ada'}, 404);
      }

      // Update data customer yang ada
      await Customers().query().where('cust_id', '=', id).update({
        'cust_name': request.body['cust_name'],
        'cust_address': request.body['cust_address'],
        'cust_city': request.body['cust_city'],
        'cust_state': request.body['cust_state'],
        'cust_zip': request.body['cust_zip'],
        'cust_country': request.body['cust_country'],
        'cust_telp': request.body['cust_telp'],
        'updated_at': DateTime.now().toIso8601String() // Menambahkan waktu pembaruan
      });

      // Mengambil data customer yang baru diperbarui
      final updatedCustomer = await Customers().query().where('cust_id', '=', id).first();

      // Mengembalikan respons yang menunjukkan data berhasil diperbarui
      return Response.json({
        'message': 'Data updated successfully',
        'data': updatedCustomer, // Menampilkan data yang sudah diperbarui
        'updated_at': updatedCustomer?['updated_at'], // Menampilkan waktu pembaruan
      });
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error updating data', 'error': e.toString()}, 500);
    }
  }

  Future<Response> destroy(int id) async {
    try {
      // Cek apakah customer dengan cust_id yang diberikan ada
      final customer =
          await Customers().query().where('cust_id', '=', id).first();

      if (customer == null) {
        // Jika customer tidak ditemukan
        return Response.json({'message': 'Customer tidak ada'}, 404);
      }

      // Menghapus data customer
      await Customers().query().where('cust_id', '=', id).delete();

      // Mengembalikan respons setelah data berhasil dihapus
      return Response.json({'message': 'Berhasil menghapus data', 'deleted_id': id, // Menyertakan ID yang dihapus untuk konfirmasi
      });
    } catch (e) {
      // Menangani kesalahan tak terduga
      return Response.json({'message': 'Error deleting data', 'error': e.toString()}, 500);
    }
  }
}

final CustomersController customersController = CustomersController();
