import  'package:powersync/powersync.dart';
import 'package:budgetit/auth/data/cognito_auth_service.dart';
import 'package:budgetit/config/app_config.dart';
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
            endpoint: AppConfig.powerSyncUrl,
            expiresAt: DateTime.now().add(const Duration(hours: 1)),
            token: JWT, 
        );
    }

    @override 
    Future<void> sendToFastAPI(Map<String, dynamic> payload ) async{
      CognitoAuthService authService = CognitoAuthService();
      final token = await authService.getJWT();
      final response = await dio.post(
        AppConfig.uploadEndpoint,
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
      if (transaction == null) return;

      final payload = {
        'operations': transaction.crud.map((op) => {
          'id': op.id,
          'op': op.op.toString().split('.').last,
          'table': op.table,
          'data': op.opData,
        }).toList(),
      };

      await sendToFastAPI(payload);
      await transaction.complete();
    }
} 