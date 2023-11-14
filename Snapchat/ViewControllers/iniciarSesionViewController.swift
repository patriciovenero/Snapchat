//
//  ViewController.swift
//  Snapchat
//
//  Created by patricio venero on 7/11/23.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseDatabaseInternal

class iniciarSesionViewController: UIViewController {
    
    
    //var credential = GoogleAuthProvider.credential(withIDToken: "",                                       accessToken: "")
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBAction func loginbutton(_ sender: Any) {
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
               if let error = error {
                   // Manejar el error, por ejemplo, mostrar un mensaje de error.
                   print("Error al iniciar sesión con Google: \(error.localizedDescription)")
               } else if let user = result?.user {
                   // La autenticación con Google fue exitosa, puedes manejar el usuario aquí.
                   print("Inicio de sesión con Google exitoso. Usuario: \(user)")
               }
           }
    }
    
    @IBOutlet weak var passwordTextField: UITextField!

    @IBAction func iniciarSecionTapped(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {(user, error) in
            print("Intentando Iniciar Secion")
            if error != nil{
                print("Se presento el siguiente error: \(error)")
                Auth.auth().createUser(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!, completion: {(user , error) in print("Intentemos crear un usuario")
                    if error != nil{
                        print("Se presento el siguiente error al crear el usuario:\(error)")
                    }else{
                        print("El usuario fue creado exitosamente")
                        
                        Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)
                        self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                        
                        let alerta = UIAlertController(title: "Creacion de usuario", message: "usuario: \(self.emailTextField.text!) se creo correctamente", preferredStyle: .alert)
                        let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: { (UIAlertAction) in
                            self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                        })
                        alerta.addAction(btnOK)
                        self.present(alerta, animated: true, completion: nil)
                    }
                })
            }else {
                print("Inicio de sesion exitoso")
                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
            }
        }
    }
    
    @IBAction func signInWithGoogleButtonTapped(_ sender: Any) {
        let database = Database.database().reference()
        let userRef = database.child("users")
        let newuserRef = userRef.childByAutoId()
        let usersData = ["name" : "jhon doe", "age" : 30] as [String : Any]
        newuserRef.setValue(usersData)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
          guard error == nil else {
            // ...
              return
            
          }

          guard let user = result?.user,
            let idToken = user.idToken?.tokenString
          else {
            // ...
              return
          }

            var credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                         accessToken: user.accessToken.tokenString)

          // ...
            
            Auth.auth().signIn(with: credential) { result, error in
                print("entro")
              // At this point, our user is signed in
            }
            
        }
        
        
        
    }
}

