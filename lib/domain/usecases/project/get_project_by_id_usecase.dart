import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/entities/project.dart';
import '../../../data/repositories/project/project_repository.dart';

class GetProjectByIdParams {
  final int id;
  GetProjectByIdParams(this.id);
}

@injectable
class GetProjectByIdUseCase implements BaseParamsUseCase<Project?, GetProjectByIdParams> {
  const GetProjectByIdUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<Project?>> call(GetProjectByIdParams params) {
    return _projectRepository.getProjectById(params.id);
  }
} 