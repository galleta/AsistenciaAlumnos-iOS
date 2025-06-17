//
//  Alumno.swift
//  APPsistencia
//
//  Created by Francis on 10/01/2019.
//  Copyright © 2019 Francis. All rights reserved.
//

import Foundation

// Esta clase representa un alumno

class Alumno
{
    private var id: Int
    private var nombre, apellidos: String
    
    public init(nid: Int, nnombre: String, napellidos: String)
    {
        id = nid
        nombre = nnombre
        apellidos = napellidos
    }
    
    public func getID() -> Int
    {
        return id
    }
    
    public func getNombre() -> String
    {
        return nombre
    }
    
    public func getApellidos() -> String
    {
        return apellidos
    }
}
