import 'package:permission_handler/permission_handler.dart';

checar_permissao() async{
  // await Permission.storage.request();


  // Verifica se a permissão para o armazenamento foi concedida
  if (await Permission.manageExternalStorage.isGranted) {
    return true;
  } else {
    // Solicita permissão para gerenciar o armazenamento
    var status = await Permission.manageExternalStorage.request();
    return status.isGranted;
  }


}