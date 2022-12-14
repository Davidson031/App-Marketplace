import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/auth_exception.dart';
import 'package:shop/models/auth.dart';

enum AuthMode { signup, login }

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm>
    with SingleTickerProviderStateMixin {
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  AuthMode _authMode = AuthMode.login;
  final Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  AnimationController? _controller;
  Animation<double>? _opacityAnimation;

  bool _isLogin() => _authMode == AuthMode.login;
  // bool _isSignup() => _authMode == AuthMode.signup;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );

    _opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller!,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  void _switchAuthMode() {
    setState(() {
      if (_isLogin()) {
        _authMode = AuthMode.signup;
        _controller?.forward();
      } else {
        _authMode = AuthMode.login;
        _controller?.reverse();
      }
    });
  }

  void _showErrorDialog(String msg) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ocorreo um Erro'),
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Future<void> _submit() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    setState(() => _isLoading = true);

    _formKey.currentState?.save();
    Auth auth = Provider.of(context, listen: false);

    try {
      if (_isLogin()) {
        // Login
        await auth.authenticate(
            _authData['email']!, _authData['password']!, 'signInWithPassword');
      } else {
        // Registrar
        await auth.authenticate(
            _authData['email']!, _authData['password']!, 'signInWithPassword');
      }
    } on AuthException catch (error) {
      _showErrorDialog(error.toString());
    } catch (error) {
      _showErrorDialog('Ocorreu um erro inesperado!');
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
        padding: const EdgeInsets.all(16),
        height: _isLogin() ? 310 : 400,
        width: deviceSize.width * 0.75,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'E-mail'),
                keyboardType: TextInputType.emailAddress,
                onSaved: (email) => _authData['email'] = email ?? '',
                validator: (_email) {
                  final email = _email ?? '';
                  if (email.trim().isEmpty || !email.contains('@')) {
                    return 'Informe um e-mail v??lido.';
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Senha'),
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: _passwordController,
                onSaved: (password) => _authData['password'] = password ?? '',
                validator: (_password) {
                  final password = _password ?? '';
                  if (password.isEmpty || password.length < 5) {
                    return 'Informe uma senha v??lida';
                  }
                  return null;
                },
              ),
              AnimatedContainer(
                constraints: BoxConstraints(
                  minHeight: _isLogin() ? 0 : 60,
                  maxHeight: _isLogin() ? 0 : 120,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
                child: FadeTransition(
                  opacity: _opacityAnimation!,
                  child: TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Confirmar Senha'),
                    keyboardType: TextInputType.emailAddress,
                    obscureText: true,
                    validator: _isLogin()
                        ? null
                        : (_password) {
                            final password = _password ?? '';
                            if (password != _passwordController.text) {
                              return 'Senhas informadas n??o conferem.';
                            }
                            return null;
                          },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 8,
                    ),
                  ),
                  child: Text(
                    _authMode == AuthMode.login ? 'ENTRAR' : 'REGISTRAR',
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: _switchAuthMode,
                child: Text(
                  _isLogin() ? 'DESEJA REGISTRAR?' : 'J?? POSSUI CONTA?',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// // ignore_for_file: sort_child_properties_last, prefer_final_fields
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:provider/provider.dart';
// import 'package:shop/models/auth.dart';
// import 'package:shop/exceptions/auth_exception.dart';

// enum AuthMode { Signup, Login }

// class AuthForm extends StatefulWidget {
//   const AuthForm({Key? key}) : super(key: key);

//   @override
//   State<AuthForm> createState() => _AuthFormState();
// }

// class _AuthFormState extends State<AuthForm>
//     with SingleTickerProviderStateMixin {
//   AuthMode _authMode = AuthMode.Login;

//   Map<String, String> _authData = {
//     'email': '',
//     'password': '',
//   };

//   AnimationController? _controller;

//   Animation<double>? _opacityAnimation;

//   final _formKey = GlobalKey<FormState>();

//   final _passwordController = TextEditingController();

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();

//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 300),
//     );

//     _opacityAnimation = Tween(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _controller!,
//       curve: Curves.linear,
//     ));
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _controller?.dispose();
//   }

//   void _switchAuthMode() {
//     setState(() {
//       if (_isLogin()) {
//         _authMode = AuthMode.Signup;
//         _controller?.forward();
//       } else {
//         _authMode = AuthMode.Login;
//         _controller?.reverse();
//       }
//     });
//   }

//   void _showErrorDialogue(String msg) {
//     showDialog(
//         context: context,
//         builder: (ctx) => AlertDialog(
//               title: const Text('Ocorreu um erro'),
//               content: Text(msg),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: const Text('Fechar'),
//                 )
//               ],
//             ));
//   }

//   Future<void> _submitForm() async {
//     final isValid = _formKey.currentState?.validate() ?? false;

//     if (!isValid) {
//       return;
//     }

//     setState(() {
//       _isLoading = true;
//     });

//     _formKey.currentState?.save();

//     Auth auth = Provider.of<Auth>(context, listen: false);

//     try {
//       if (_isLogin()) {
//         await auth.authenticate(
//             _authData['email']!, _authData['password']!, 'signInWithPassword');
//       } else {
//         await auth.authenticate(
//             _authData['email']!, _authData['password']!, 'signUp');
//       }

//       setState(() {
//         _isLoading = true;
//       });
//     } on AuthException catch (err) {
//       _showErrorDialogue(err.toString());
//     } catch (err) {
//       _showErrorDialogue("Ocorreu um erro Inesperado");
//     }

//     setState(() {
//       _isLoading = false;
//     });
//   }

//   bool _isLogin() {
//     return _authMode == AuthMode.Login;
//   }

//   bool _isSignUp() {
//     return _authMode == AuthMode.Signup;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final deviceSize = MediaQuery.of(context).size;

//     return Card(
//       elevation: 8,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeIn,
//         padding: const EdgeInsets.all(15),
//         height: _isLogin() ? 310 : 400,
//         width: deviceSize.width * 0.75,
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'E-mail: '),
//                 keyboardType: TextInputType.emailAddress,
//                 onSaved: (email) => _authData['email'] = email ?? '',
//                 validator: (_email) {
//                   final email = _email ?? '';
//                   if (email.trim().isEmpty || !email.contains('@')) {
//                     return 'Informe um e-mail v??lido';
//                   }
//                   return null;
//                 },
//               ),
//               TextFormField(
//                 decoration: const InputDecoration(labelText: 'Senha: '),
//                 obscureText: true,
//                 onSaved: (password) => _authData['password'] = password ?? '',
//                 controller: _passwordController,
//                 validator: (_password) {
//                   final password = _password ?? '';
//                   if (password.isEmpty || password.length < 5) {
//                     return 'Informe uma senha v??lida';
//                   }
//                   return null;
//                 },
//               ),
//               AnimatedContainer(
//                 constraints: BoxConstraints(
//                     minHeight: _isLogin() ? 0 : 60,
//                     maxHeight: _isLogin() ? 0 : 120),
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.linear,
//                 child: FadeTransition(
//                   opacity: _opacityAnimation!,
//                   child: TextFormField(
//                       decoration:
//                           const InputDecoration(labelText: 'Confirmar Senha: '),
//                       obscureText: true,
//                       validator: _isLogin()
//                           ? null
//                           : (_password) {
//                               final password = _password ?? '';
//                               if (password != _passwordController.text) {
//                                 return 'Senhas informadas n??o conferem';
//                               }
//                               return null;
//                             }),
//                 ),
//               ),
//               const SizedBox(height: 50),
//               if (_isLoading)
//                 const CircularProgressIndicator()
//               else
//                 ElevatedButton(
//                   onPressed: _submitForm,
//                   style: ElevatedButton.styleFrom(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 30,
//                       vertical: 8,
//                     ),
//                   ),
//                   child: Text(
//                     _isLogin() ? 'ENTRAR' : 'REGISTRAR',
//                   ),
//                 ),
//               const Spacer(),
//               TextButton(
//                 onPressed: _switchAuthMode,
//                 child: Text(
//                   _isLogin() ? 'DESEJA REGISTRAR?' : 'J?? POSSUI CONTA?',
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
