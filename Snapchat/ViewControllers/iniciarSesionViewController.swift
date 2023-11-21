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
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                print("Intentando Iniciar Sesión")
                
                if error != nil {
                    print("Se presentó el siguiente error: \(error)")
                    
                    // El usuario no existe, mostrar alerta para crear usuario
                    let alerta = UIAlertController(title: "Error", message: "El usuario no existe. ¿Quieres crear uno nuevo?", preferredStyle: .alert)
                    
                    let btnCrear = UIAlertAction(title: "Crear", style: .default) { (UIAlertAction) in
                        // Mostrar la vista para crear usuario
                        self.performSegue(withIdentifier: "registerSegue", sender: nil)
                    }
                    
                    let btnCancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
                    
                    alerta.addAction(btnCrear)
                    alerta.addAction(btnCancelar)
                    
                    self.present(alerta, animated: true, completion: nil)
                } else {
                    print("Inicio de sesión exitoso")
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

