import 'package:rest_api/app/models/vendors.dart';
import 'package:vania/vania.dart';

class VendorsController extends Controller {

    Future<Response> index() async {
      final vendors = await Vendors().query().get();

      if (vendors.isEmpty) {
        return Response.json({'message': 'No data found', 'data': []}, 404);
      }

      return Response.json({'message': 'Data Vendor', 'data': vendors}, 200);
    }

    Future<Response> store(Request request) async {
      try {
        // Validasi input
        if (request.body['vend_id'] == null || request.body['vend_id'].isEmpty) {
          return Response.json({'message': 'vend_id harus diisi'}, 400);
        }

        if (request.body['vend_name'] == null || request.body['vend_name'].isEmpty) {
          return Response.json({'message': 'vend_name harus diisi'}, 400);
        }

        // Periksa apakah vend_id sudah ada
        final existingVendor = await Vendors().query().where('vend_id', '=', request.body['vend_id']).first();
        if (existingVendor != null) {
          return Response.json({'message': 'vend_id sudah ada'}, 409); // Jika vend_id sudah ada
        }

        // Menyimpan data ke dalam database
        final newVendor = {
          'vend_id': request.body['vend_id'],
          'vend_name': request.body['vend_name'],
          'vend_address': request.body['vend_address'],
          'vend_kota': request.body['vend_kota'],
          'vend_state': request.body['vend_state'],
          'vend_zip': request.body['vend_zip'],
          'vend_country': request.body['vend_country'],
        };

        await Vendors().query().insert(newVendor);

        // Respons sukses dengan data yang dimasukkan
        return Response.json({
          'message': 'Berhasil menambahkan data',
          'data': newVendor,
        }, 201);
      } catch (e) {
        // Menangani kesalahan tak terduga
        return Response.json({
          'message': 'Terjadi kesalahan saat menambahkan data',
          'error': e.toString(),
        }, 500);
      }
    }

    Future<Response> show(int id) async {
      try {
        final vendor = await Vendors().query().where('vend_id', '=', id).first();

        if (vendor == null) {
          return Response.json({'message': 'Data not found'}, 404);
        }

        return Response.json({'message': 'Data found', 'data': vendor}, 200);
      } catch (e) {
        return Response.json({
          'message': 'Terjadi kesalahan pada server',
          'error': e.toString(),
        }, 500);
      }
    }

    Future<Response> update(Request request,int id) async {
      try {
        // Validasi jika data yang ingin diupdate ada
        final vendorExists = await Vendors().query().where('vend_id', '=', id).first();

        if (vendorExists == null) {
          return Response.json({'message': 'Data not found'}, 404);
        }

        // Melakukan update data
        final rowsAffected = await Vendors().query().where('vend_id', '=', id).update({
          'vend_name': request.body['vend_name'],
          'vend_address': request.body['vend_address'],
          'vend_kota': request.body['vend_kota'],
          'vend_state': request.body['vend_state'],
          'vend_zip': request.body['vend_zip'],
          'vend_country': request.body['vend_country'],
        });

        if (rowsAffected == 0) {
          return Response.json({'message': 'No changes made'}, 200);
        }
        return Response.json({'message': 'Data updated successfully'}, 200);
      } catch (e) {
        return Response.json({
          'message': 'Terjadi kesalahan pada server',
          'error': e.toString(),
        }, 500);
      }
    } 

    Future<Response> destroy(int id) async {
      try {
        // Periksa apakah data ada
        final vendor = await Vendors().query().where('vend_id', '=', id).first();

        if (vendor == null) {
          return Response.json({'message': 'Data not found'}, 404);
        }

        // Hapus data
        await Vendors().query().where('vend_id', '=', id).delete();
        return Response.json({'message': 'Data deleted successfully'}, 200);
      } catch (e) {
        return Response.json({
          'message': 'Terjadi kesalahan pada server',
          'error': e.toString(),
        }, 500);
      }
    }
}

final VendorsController vendorsController = VendorsController();

