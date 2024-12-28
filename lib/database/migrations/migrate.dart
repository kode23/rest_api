import 'dart:io';
import 'package:rest_api/database/migrations/create_customers_table.dart';
import 'package:vania/vania.dart';
// import 'create_users_table.dart';
import 'create_product_table.dart';
import 'create_orders_table.dart';
import 'create_vendors_table.dart';
import 'create_orderitems_table.dart';
import 'create_productnotes_table.dart';

void main(List<String> args) async {
  await MigrationConnection().setup();
  if (args.isNotEmpty && args.first.toLowerCase() == "migrate:fresh") {
    await Migrate().dropTables();
  } else {
    await Migrate().registry();
  }
  await MigrationConnection().closeConnection();
  exit(0);
}

class Migrate {
  registry() async {
		 await CreateCustomersTable().up();
    //  await CreateUserTable().up();
     await CreateProductTable().up();
		 await CreateOrdersTable().up();
		 await CreateVendorsTable().up();
		 await CreateOrderitemsTable().up();
		 await CreateProductnotesTable().up();
	}

  dropTables() async {
		 await CreateProductnotesTable().down();
		 await CreateOrderitemsTable().down();
		 await CreateVendorsTable().down();
		 await CreateOrdersTable().down();
		 await CreateCustomersTable().down();
     await CreateProductTable().down();
    //  await CreateUserTable().down();
	 }
}
