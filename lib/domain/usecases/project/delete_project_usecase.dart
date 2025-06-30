import 'package:injectable/injectable.dart';
import '../../../application/core/commundomain/entitties/based_api_result/api_result_model.dart';
import '../../../application/core/commundomain/usecases/base_params_usecase.dart';
import '../../../data/repositories/project/project_repository.dart';

class DeleteProjectParams {
  final int id;
  DeleteProjectParams(this.id);
}

@injectable
class DeleteProjectUseCase implements BaseParamsUseCase<void, DeleteProjectParams> {
  const DeleteProjectUseCase(this._projectRepository);
  final ProjectRepository _projectRepository;

  @override
  Future<ApiResultModel<void>> call(DeleteProjectParams params) {
    return _projectRepository.deleteProject(params.id);
  }
} 