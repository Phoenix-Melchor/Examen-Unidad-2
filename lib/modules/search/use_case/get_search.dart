import 'package:examen_johan_melchor/modules/search/domain/dto/search.dart';
import 'package:examen_johan_melchor/modules/search/domain/repository/search_repository.dart';

class GetSearchResults {
  final SearchRepository searchRepository;

  GetSearchResults(this.searchRepository);

  Future<List<SearchResult>> execute(String query) {
    return searchRepository.searchProducts(query);
  }
}
