import 'package:examen_johan_melchor/infrastructure/app/use_case.dart';
import 'package:examen_johan_melchor/modules/categories/domain/repository/category_repository.dart';
import 'package:examen_johan_melchor/modules/categories/domain/dto/category.dart';

class GetCategoriesUseCase {
  final CategoryRepository categoryRepository;

  GetCategoriesUseCase(this.categoryRepository);

  Future<List<Category>> execute() {
    return categoryRepository.getAll();
  }
}
