import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:owmasefasedois/Pages/home_page.dart';
import 'package:owmasefasedois/Pages/loginScreen.dart';
import 'package:owmasefasedois/methods/common_methods.dart';
import 'package:owmasefasedois/widgets/loading_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key : key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController emailtextEditingController = TextEditingController();
  TextEditingController senhatextEditingController = TextEditingController();
  TextEditingController repetirSenhaEditingControler = TextEditingController();
  CommonMethods cMetodo =  CommonMethods();

  checkIfNetworkIsAvailable(){
    cMetodo.checkConnectivity(context);
    signUpFormValidation();

  }

  signUpFormValidation(){
    if(emailtextEditingController.text.trim().length < 3){
      cMetodo.displaySnackBar("nome do email tem que ter mais de três caracteres", context);
    }else if(senhatextEditingController.text.trim().length<6){
      cMetodo.displaySnackBar("A senha não pode estar vazia e deve ter no mínimo 5 caracteres", context);
    }else if(senhatextEditingController.text != repetirSenhaEditingControler.text){
      cMetodo.displaySnackBar("as senhas não são iguais, tente novamente", context);
    }else if(!emailtextEditingController.text.contains("@")){
      cMetodo.displaySnackBar("Não é um email válido", context);
    }else{
      registrarNovoUsuario();
    }
  }

  registrarNovoUsuario() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Registrando sua conta"),
    );

    final User? userFaribase = (
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailtextEditingController.text.trim(),
      password: senhatextEditingController.text.trim(),
    ).catchError((errorMsg)
    {
      cMetodo.displaySnackBar(errorMsg.toString(), context);
    }
    )
    ).user;

    if(!context.mounted) return;
    Navigator.pop(context);

    DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFaribase!.uid);
    Map userDataMap = {
      "email": emailtextEditingController.text.trim(),
      "password": senhatextEditingController.text.trim(),
      "id": userFaribase.uid,
      "blockStatus": "no",
      };
    usersRef.set(userDataMap);
    Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(

        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              SizedBox(height: 80,),
              Image.asset(
                "assets/images/owmae_laranja_roxo.png",
                width: 200.0,
                height: 200.0,
              ),

              SizedBox(height: 30.0,),

              // titulo da pagina
              const Text(
                'Criar conta de Usuário',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              // campo do email
              Padding(padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Usuário",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 22,),

              //Campo senha
           Padding(padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                     controller: senhatextEditingController,
                     obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Senha",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 22,),

              //Campo repetir senha
              Padding(padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: repetirSenhaEditingControler,
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Repetir a senha",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    )
                  ],
                ),
              ),

              SizedBox(height: 22,),

              ElevatedButton(
                onPressed: (



                    ){

                  checkIfNetworkIsAvailable();

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amberAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 80.0,)
                ),
                child: const Text("Cadastro"),

              ),

              TextButton(
                onPressed: (

                    ){

                  Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));

                },
                child: const Text(
                  "Possui uma conta? Faça o login aqui",
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),

            ],

          ),
        ),
      ),
    );
  }
}
