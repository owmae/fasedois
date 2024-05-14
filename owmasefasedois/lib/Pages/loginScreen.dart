import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:owmasefasedois/Pages/home_page.dart';
import 'package:owmasefasedois/Pages/signUp_screen.dart';
import 'package:owmasefasedois/global/global_var.dart';
import 'package:owmasefasedois/widgets/loading_dialog.dart';
import 'package:owmasefasedois/methods/common_methods.dart';
class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailtextEditingController = TextEditingController();

  TextEditingController senhatextEditingController = TextEditingController();

  CommonMethods cMetodo = CommonMethods();

  checkIfNetworkIsAvailable(){
    cMetodo.checkConnectivity(context);
    signUpFormValidation();

  }

  signUpFormValidation(){
    if(emailtextEditingController.text.trim().length < 3){
      cMetodo.displaySnackBar("nome do email tem que ter mais de três caracteres", context);
    }else if(senhatextEditingController.text.trim().length<6){
      cMetodo.displaySnackBar("A senha não pode estar vazia e deve ter no mínimo 5 caracteres", context);
    }else if(!emailtextEditingController.text.contains("@")){
      cMetodo.displaySnackBar("Não é um email válido", context);
    }else{
      conectarUsuario();
    }
  }

  conectarUsuario() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDialog(messageText: "Acessando o usuário"),
    );

    final User? userFaribase = (
        await FirebaseAuth.instance.signInWithEmailAndPassword(
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

    if(userFaribase != null)
    {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFaribase.uid);
      usersRef.once().then((snap)
      {
        if(snap.snapshot.value != null)
        {
          if((snap.snapshot.value as Map)["blockStatus"] == "no"){
           userEmail = (snap.snapshot.value as Map)["email"];
            Navigator.push(context, MaterialPageRoute(builder: (c) => const HomePage()));

          }
          else{

            cMetodo.displaySnackBar("Essa conta está bloqueada. Contacte a Adm.", context);
            FirebaseAuth.instance.signOut();
          }
        }
        else
        {
          cMetodo.displaySnackBar("Este cadastro não existe", context);

        }

      });

      }
    }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Image.asset(
                  "assets/images/owmae_laranja_roxo.png"
              ),

              // titulo da pagina
              const Text(
                'Login do Usuário',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // campo do email
              Padding(padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      controller: emailtextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Usuário",
                        labelStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
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

              const SizedBox(height: 22,),

              //Campo senha
              Padding(padding: const EdgeInsets.all(10),
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
                          color: Colors.white,
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

              const SizedBox(height: 22,),

              const SizedBox(height: 22,),

              ElevatedButton(
                onPressed: (){
                  checkIfNetworkIsAvailable();


                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    padding: const EdgeInsets.symmetric(horizontal: 80.0,)
                ),
                child: const Text("Login",
                style: TextStyle(fontSize: 18,
                color: Colors.white),
                ),
              ),

              TextButton(
                onPressed: (

                    ){
                  Navigator.push(context, MaterialPageRoute(builder: (c) => const SignUpScreen()));

                },
                child: const Text(
                  "Possui uma conta? Faça o login aqui",
                  style: TextStyle(
                    color: Colors.white,
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
