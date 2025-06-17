//
//  SlidingViewController.swift
//  APPsistenciav2
//
//  Created by Francis on 29/01/2019.
//  Copyright © 2019 Francis. All rights reserved.
//

import UIKit
import NavigationDrawer

class SlidingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    var interactor:Interactor? = nil
    @IBOutlet weak var lCorreo: UILabel!
    
    // Lista (array) de los nombres de los menús
    let menulistaadmin = ["Alumnos", "Agregar alumno", "Consultar/Eliminar alumnos", "Profesores", "Agregar profesor", "Consultar/Eliminar profesores", "Mis datos", "Asistencia", "Anotar asistencia", "Consultar asistencia", "Consultar faltas alumno", "Modificar/Borrar asistencia", "Borrar todas las asistencias", "Configuración", "Configuración", "Información", "Sobre la app"]
    let tipomenulistaadmin = ["Cabecera", "Menu", "Menu", "Cabecera", "Menu", "Menu", "Menu", "Cabecera", "Menu", "Menu", "Menu", "Menu", "Menu", "Cabecera", "Menu", "Cabecera", "Menu"]
    
    @objc func goBack()
    {
        dismiss(animated: true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Pillo el usuario guardado
        let preferencias = UserDefaults.standard
        let usuario = preferencias.object(forKey: "usuario") as! String
        lCorreo.text = usuario + CORREO
        
        aplicarEstilos()
    }
    

    //Handle Gesture
    @IBAction func handleGesture(sender: UIPanGestureRecognizer)
    {
        let translation = sender.translation(in: view)
        
        let progress = MenuHelper.calculateProgress(translationInView: translation, viewBounds: view.bounds, direction: .Left)
        
        MenuHelper.mapGestureStateToInteractor(
            gestureState: sender.state,
            progress: progress,
            interactor: interactor){
                self.dismiss(animated: true, completion: nil)
        }
    }
    
    @IBAction func closeBtnPressed(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    func aplicarEstilos() -> Void
    {
        lCorreo.setStyle2(with: estilotextousuariodrawer)
    }
    
    // Este método abre la pantalla de Consultar alumnos
    func irAConsultarAlumnos()
    {
        if let resultController = storyboard!.instantiateViewController(withIdentifier: "ConsultarAlumnosViewController") as? ConsultarAlumnosViewController
        {
            // Cambio el icono de la barra de navegación por el icono de la flecha atrás
            let button = UIButton.init(type: .custom)
            button.setImage(UIImage(named: "flechaatras.png"), for: UIControl.State.normal)
            button.addTarget(self, action: #selector(goBack), for: UIControl.Event.touchUpInside)
            let barButton = UIBarButtonItem(customView: button)
            resultController.navigationItem.leftBarButtonItem = barButton
            
            //resultController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(goBack))
            let navController = UINavigationController(rootViewController: resultController) // Creating a navigation controller with resultController at the root of the navigation stack.
            resultController.title = "Consultar alumnos"
            self.present(navController, animated:true, completion: nil)
        }
    }
    
    // Funciones de los protocolos para las celdas personalidazas
    
    // Devuelve el número de celdas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return menulistaadmin.count
    }
    
    // Crea cada celda una por una
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath) as! DrawerMenuTableViewCell
        cell.textomenu.text = menulistaadmin[indexPath.row]
        
        if tipomenulistaadmin[indexPath.row] == "Cabecera"
        {
            cell.imagenmenu.isHidden = true
            // Aplico estilos al texto del menú
            cell.textomenu.setStyle2(with: estilotextocabecera)
        }
        else
        {
            cell.imagenmenu.isHidden = false
            // Aplico estilos al texto del menú
            cell.textomenu.setStyle2(with: estilotextomenu)
        }
        
        //cell.imageCell.image = UIImage(named: exercisesList[indexPath.row])
        
        return cell
    }
    
    // Método para detectar el click en una celda de la tabla
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let currentItem = menulistaadmin[indexPath.row]
        
        //print("Has pulsado en el menú \(currentItem)")
        
        switch currentItem
        {
        case "Agregar alumno":
            print("eee")
        case "Consultar/Eliminar alumnos":
            irAConsultarAlumnos()
        default:
            print("No válido")
        }
    }

}
