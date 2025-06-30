import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/project.dart';
import '../../../data/repositories/project/project_repository.dart';

@injectable
class GetProjectsUseCase implements BaseParamsUseCase<List<Project>?, NoParams> {
  const GetProjectsUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<List<Project>?>> call(NoParams params) {
    return _projectRepository.getProjects();
  }
} 