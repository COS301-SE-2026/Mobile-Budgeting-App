import  'package:powersync/powersync.dart';
import 'package:budgetit/auth/data/cognito_auth_service.dart';
import 'package:dio/dio.dart';



class PSyncConnector extends PowerSyncBackendConnector{
    final dio = Dio();

    @override 
    Future<PowerSyncCredentials> fetchCredentials() async {
        CognitoAuthService authService = CognitoAuthService();
        final String? JWT = await authService.getJWT();
        if(JWT == null){
            throw Exception("JWT is null");
        }
        return PowerSyncCredentials(
            endpoint:'' , //TODO set UP powersync container in docker
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
            token: JWT, 
        );
    }

    @override 
    Future<void> sendToFastAPI(Map<String, dynamic> payload ) async{
      CognitoAuthService authService = CognitoAuthService();
      final token = await authService.getJWT();
      final response = await dio.post(
        "", //TODO put fastapi endpoint here
        data: payload,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
        if(response.statusCode != 200){
          throw Exception("Upload failed");
        }
      
    }
    @override
    Future<void> uploadData(PowerSyncDatabase database) async {
      final transaction = await database.getNextCrudTransaction();
      if(transaction == null) return;
      for (final operation in transaction.crud) {
        final payload = {
          'table': operation.table,
          'operation': operation.toJson(),
        };
        await sendToFastAPI(payload);
      }
      
    }
} 