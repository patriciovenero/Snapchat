//
//  RegisterViewController.swift
//  Snapchat
//
//  Created by patricio venero on 21/11/23.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController {

    @IBOutlet weak var labelusuario: UITextField!
    
    @IBOutlet weak var labelpassword: UITextField!
    
    @IBAction func btnregister(_ sender: Any) {
        // Verificar que los campos de usuario y contraseña no estén vacíos
             guard let email = labelusuario.text, !email.isEmpty,
                   let password = labelpassword.text, !password.isEmpty else {
                 // Mostrar una alerta indicando que los campos son obligatorios
                 let alerta = UIAlertController(title: "Error", message: "Por favor, completa todos los campos.", preferredStyle: .alert)
                 let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                 alerta.addAction(btnOK)
                 self.present(alerta, animated: true, completion: nil)
                 return
             }

             // Crear el usuario con Firebase Authentication
             Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                 if let error = error {
                     print("Error al crear el usuario: \(error.localizedDescription)")

                     // Mostrar una alerta con el mensaje de error
                     let alerta = UIAlertController(title: "Error", message: "No se pudo crear el usuario. \(error.localizedDescription)", preferredStyle: .alert)
                     let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                     alerta.addAction(btnOK)
                     self.present(alerta, animated: true, completion: nil)
                 } else {
                     print("Usuario creado exitosamente")

                     // Almacenar información adicional del usuario en la base de datos
                     Database.database().reference().child("usuarios").child(user!.user.uid).child("email").setValue(user!.user.email)

                     // Mostrar una alerta indicando que el usuario se creó correctamente
                     let alerta = UIAlertController(title: "Registro exitoso", message: "Usuario \(email) creado correctamente.", preferredStyle: .alert)
                     let btnOK = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in
                                 // Realizar la transición al UINavigationController con el segundo segue
                                 self.performSegue(withIdentifier: "registerSegue2", sender: nil)
                     }
                     alerta.addAction(btnOK)
                     self.present(alerta, animated: true, completion: nil)

                     // Puedes agregar código adicional aquí, como navegar a otra vista si es necesario
                 }
             }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
