import 'package:resq_tools/models/substance/substance_result.dart';

class SubstanceRepository {
  Future<SubstanceResult> fetchSubstance() async {
    //TODO: make network request
    await Future.delayed(const Duration(seconds: 1));

    return SubstanceResult(
      name: 'Benzin',
      hazardNumber: 33,
      unNumber: 1203,
      properties: 'Extrem entzündbare Flüssigkeit',
    );
  }
}
