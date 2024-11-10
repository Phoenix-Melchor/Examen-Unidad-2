import 'package:examen_johan_melchor/modules/productsbyid/domain/repository/productsbyid_repository.dart';
import 'package:examen_johan_melchor/infrastructure/preference_service.dart';
import 'package:examen_johan_melchor/modules/productsbyid/domain/dto/productsbyid.dart';

class GetProductbyid {
  final ProductsbyidRepository productDetailRepository;
  final PreferencesService preferencesService;

  GetProductbyid({
    required this.productDetailRepository,
    required this.preferencesService,
  });

  Future<ProductDetail> execute(int productId) async {
    // Validar el token antes de hacer la solicitud
    String? token = await preferencesService.getAuthToken();
    if (token == null) {
      throw Exception('Token not found');
    }
    return productDetailRepository.getProductDetail(productId);
  }
}
