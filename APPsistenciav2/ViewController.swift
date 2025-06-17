//
//  ViewController.swift
//  APPsistenciav2
//
//  Created by Francis on 25/01/2019.
//  Copyright © 2019 Francis. All rights reserved.
//

// Prefencias -> https://www.hackingwithswift.com/example-code/system/how-to-save-user-settings-using-userdefaults

import UIKit
import SwiftyJSON

class ViewController: UIViewController
{
    @IBOutlet weak var lUsuario: UITextField!
    @IBOutlet weak var lPassword: UITextField!
    @IBOutlet weak var sRecordarme: UISwitch!
    @IBOutlet weak var bLogin: UIButton!    
    @IBOutlet weak var lTextoRecuerdame: UILabel!
    @IBOutlet var vistaAPP: UIView!
    @IBOutlet weak var stackPrincipal: UIStackView!
    @IBOutlet weak var stackDatosInicioSesion: UIStackView!
    
    // Hago que se muestre la barra de status
    /*override var prefersStatusBarHidden: Bool {
     return false
     }*/
    
    @IBAction func funcionBotonLogin(_ sender: UIButton)
    {
        //print("Voy a hacer un login")
        
        let usuario = lUsuario.text!
        let contrasena = lPassword.text!
        var recordarme = sRecordarme.isOn
        
        if ((lUsuario.text?.isEmpty)! || (lPassword.text?.isEmpty)!)
        {
            // Creamos la alerta
            let alert = UIAlertController(title: "Faltan datos", message: "Faltan datos para el inicio de sesión", preferredStyle: UIAlertController.Style.alert)
            // Añadimos un botón
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            // Mostramos la alerta
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            let jsp = JSONParser()
            let parametrosurl = ["emailprofesor" : usuario + CORREO, "password" : contrasena]
            
            /*var resultado = servidor.loginProfesor2(usuario: usuario + CORREO, password: contrasena)
             
            print("El resultado del login es: \(resultado)")*/
            
            jsp.getJSONFromURL(urlLogin, parametros: parametrosurl)
            { (json) in
                // Para realizar cambios en la interfaz de usuario
                DispatchQueue.main.async
                    {
                        // Convierto el objeto de tipo __NSArrayM a un array de String-String
                        guard let jsonArray = json as? [[String: String]] else
                        {
                            return
                        }
                        
                        //print("Me ha dado \(jsonArray)")
                        
                        // Obtengo el JSON donde está el dato registrado
                        var jsonregistrado = jsonArray[0]
                        // Obtengo la clave registrado del json devuelto
                        let registrado = jsonregistrado["registrado"] as? String
                        
                        //print("Me ha dado \(registrado)")
                        
                        if registrado == "ok"
                        {
                            //print("Login ok")
                            // Guardo las preferencias
                            //print("Voy a guardar las preferencias")
                            let defaults = UserDefaults.standard
                            defaults.set(usuario, forKey: "usuario")
                            defaults.set(recordarme, forKey: "recordarme")
                            // Borro los textos
                            self.lUsuario.text = ""
                            self.lPassword.text = ""
                            // Voy a la pantalla principal
                            self.performSegue(withIdentifier: "seguelogin", sender: nil)
                        }
                        else
                        {
                            //print("Login no ok")
                            // Creamos la alerta
                            let alert = UIAlertController(title: "ERROR", message: "Datos de inicio incorrectos", preferredStyle: UIAlertController.Style.alert)
                            // Añadimos un botón
                            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                            // Mostramos la alerta
                            self.present(alert, animated: true, completion: nil)
                        }
                }
            }
        }
    }
    
    /*@discardableResult func loginProfesor<T>(usuario: String, password: String, _ block: @escaping () -> T) -> T
     {
     let queue = DispatchQueue.global()
     let group = DispatchGroup()
     var result: T?
     print("paso por aqui con \(usuario)")
     group.enter()
     queue.async(group: group)
     {
     result = block();
     if( usuario == "francis@itponiente.com" )
     {
     result! = true as! T
     }
     else
     {
     result! = false as! T
     }
     group.leave();
     }
     group.wait()
     
     return result!
     }*/
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Aplico los estilos a los elementos
        aplicarEstilos()
        
        // Compruebo si el usuario dejó la sesión iniciada
        comprobarSesionIniciada()
    }
    
    func comprobarSesionIniciada() -> Void
    {
        // Compruebo si el usuario dejó activada la opción de recordar contraseña
        let preferencias = UserDefaults.standard
        if (preferencias.object(forKey: "recordarme") != nil)
        {
            var recordarme = preferencias.bool(forKey: "recordarme")
            if( recordarme )
            {
                //print("Sesión iniciada con \(usu)")
                // Si el usuario ya tenía la sesión iniciada me voy a la pantalla principal
                performSegue(withIdentifier: "seguelogin", sender: nil)
            }
        }
    }

    func aplicarEstilos() -> Void
    {
        lTextoRecuerdame.setStyle2(with: estilotexto2)
        bLogin.setStyle(title: "Acceder", style: estiloboton, backgroundcolor: .colorPrimaryDark)
        vistaAPP.setStyle(with: estilofondoPrimaryDark)
        stackDatosInicioSesion.setStyle(with: estilofondoBlanco)
        
        stackDatosInicioSesion.setPadding(top: 20, left: 20, bottom: 20, right: 20)
    }
    
    // Este método se ejecuta cuando hay un cambio de pantalla
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Pongo el texto del navigation view a nulo
        //navigationItem.title = nil
        // Si se ejecuta el segue pizza se ejecuta esto
        if segue.identifier == "seguelogin"
        {
            // Cambio el texto del botón atrás
            //navigationItem.title = ""
            // Creo un navigation view y le pongo texto en el centro
            let vc = segue.destination as UIViewController
            vc.navigationItem.title = "APPsistencia"
            // Deshabilito el botón de atrás
            vc.navigationItem.hidesBackButton = true
        }
    }
    
    // Este método se ejecuta cuando se lanza un segue
    // Para que el segue se ejecute hay que devolver true, para que no se ejecute hay que devolver false
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool
    {
        // Pongo el devolver a false para que no se ejecute el segue al pulsar el botón
        // Lo ejecutaré yo si la sesión se ha iniciado ok
        var devolver = false
        
        return devolver
    }



}

