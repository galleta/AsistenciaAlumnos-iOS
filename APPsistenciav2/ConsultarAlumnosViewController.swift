//
//  ConsultarAlumnosViewController.swift
//  APPsistenciav2
//
//  Created by Francis on 29/01/2019.
//  Copyright © 2019 Francis. All rights reserved.
//

// https://icons8.com/icon/1806/back

import UIKit

class ConsultarAlumnosViewController: UIViewController, LBZSpinnerDelegate, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var spAlumnos: LBZSpinner!
    @IBOutlet weak var spCursos: LBZSpinner!
    @IBOutlet weak var tablaAlumnos: UITableView!
    
    @IBOutlet weak var lCicloFormativo: UILabel!
    @IBOutlet weak var lCurso: UILabel!
    
    private var cicloelegido = "SMR"
    private var cursoelegido = "PRIMERO"
    
    var alumnosobtenidos : [Alumno] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        spAlumnos.updateList(listaciclos)
        spAlumnos.changeSelectedIndex(0)
        // Doy funcionalidad al Spinner para cuando se seleccione un valor
        spAlumnos.delegate = self
        
        spCursos.updateList(listacursos)
        spCursos.changeSelectedIndex(0)
        // Doy funcionalidad al Spinner para cuando se seleccione un valor
        spCursos.delegate = self
        
        // Indico el tamaño de la celda de la tabla
        self.tablaAlumnos.rowHeight = 110;
        
        aplicarEstilos()
        
        // Obtengo los alumnos
        obtenerAlumnos()
    }
    

    // Este método es el listener para cuando cambie un valor de un spinner
    func spinnerChoose(_ spinner:LBZSpinner, index:Int,value:String)
    {
        switch spinner
        {
            case spAlumnos:
                cicloelegido = value
            case spCursos:
                cursoelegido = value
            default:
                print ("No es ninguno de estos")
        }
        
        obtenerAlumnos()
    }
    
    func obtenerAlumnos()
    {
        // Obtengo los alumnos del curso y ciclo elegidos
        let jsp = JSONParser()
        let parametrosurl = ["ciclo" : cicloelegido, "curso" : cursoelegido]
        
        jsp.getJSONFromURL(urlObtenerAlumnosCicloCurso, parametros: parametrosurl)
        { (json) in
            // Para realizar cambios en la interfaz de usuario
            DispatchQueue.main.async
                {
                    // Convierto el objeto de tipo __NSArrayM a un array de String-Any
                    guard let jsonArray = json as? [[String: String]] else
                    {
                        return
                    }
                    
                    self.alumnosobtenidos.removeAll()
                    
                    for i in stride(from: 0, through: jsonArray.count-1, by: 1)
                    {
                        // Obtengo los datos del json
                        let idalumno = jsonArray[i]["id"]!
                        let nombrealumno = jsonArray[i]["nombre"]!
                        let apellidosalumnos = jsonArray[i]["apellidos"]!
                        //print("Alumno: \(nombrealumno) \(apellidosalumnos)")
                        // Convierto el ID del alumno a un Int
                        guard let idfinal = Int(idalumno) else {
                            break
                        }
                        // Creo un alumno a partir de los datos obtenidos del servidor
                        let alumno = Alumno(nid: Int(idfinal), nnombre: nombrealumno , napellidos: apellidosalumnos)
                        // Agrego el alumno al array
                        self.alumnosobtenidos.append(alumno)
                    }
                    // Recargo la tabla con los datos de los alumnos
                    self.reload(tableView: self.tablaAlumnos)
                    //print("Hay \(alumnosobtenidos.count) alumnos")
            }
        }
    }
    
    func aplicarEstilos()
    {
        lCicloFormativo.setStyle2(with: estilotexto3)
        lCurso.setStyle2(with: estilotexto3)
    }
    
    // Funciones del protocolo de la UITableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.alumnosobtenidos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MostrarAlumnoCell", for: indexPath) as! MostrarAlumnosTableViewCell
        cell.lNombreAlumno.text = alumnosobtenidos[indexPath.row].getNombre()
        cell.lApellidosAlumno.text = alumnosobtenidos[indexPath.row].getApellidos()
        
        // Aplico los estilos para los textos
        cell.lNombreAlumno.setStyle2(with: estilotexto3)
        cell.lApellidosAlumno.setStyle2(with: estilotexto3)
        cell.lEtiquetaNombre.setStyle2(with: estilotexto3)
        cell.lEtiquetaApellido.setStyle2(with: estilotexto3)
        
        return cell
    }
    
    // ---------------
    
    // Recarga los datos de una UITableView
    private func reload(tableView: UITableView)
    {
        let contentOffset = tableView.contentOffset
        tableView.reloadData()
        tableView.layoutIfNeeded()
        tableView.setContentOffset(contentOffset, animated: false)
    }

}
