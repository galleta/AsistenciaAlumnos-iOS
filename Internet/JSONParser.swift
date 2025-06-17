//
//  JSONParser.swift
//  APPsistencia
//
//  Created by Francis on 24/10/2018.
//  Copyright © 2018 Francis. All rights reserved.
//

import Foundation

class JSONParser
{
    
    init() {  }
    
    /**
     Formatea los parámetros necesarios para una conexión POST con una url HTTPS
     @param parametros: Lista de parámetros de la conexión
     @return Devuelve un String con los parámetros formateados para la conexión POST
     */
    private func formatearParametros(_ parametros: Dictionary<String, String>) -> String
    {
        var devolver = ""
        
        for parametro in parametros
        {
            devolver = devolver + parametro.key + "=" + parametro.value + "&"
        }
        devolver.removeLast()
        
        return devolver
    }
    
    /**
     Obtiene un JSON de una dirección URL
     @param JsonUrl: URL para obtener el JSON
     @param parametros: Parámetros POST para la URL, si no hay parámetros se pasará un Dictionary<String, String> vacío
     */
    func getJSONFromURL(_ JsonUrl: String, parametros: Dictionary<String, String>, Completion block: @escaping ((NSArray) -> ()))
    {
        var parametrosformateados = ""
        
        if !parametros.isEmpty
        {
            parametrosformateados = formatearParametros(parametros)
        }
        
        var request = URLRequest(url: URL(string: JsonUrl)!)
        request.httpMethod = "POST"
        request.httpBody = parametrosformateados.data(using: .utf8)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let e = error{
                print(e.localizedDescription)
            }
            else{
                if let content = data{
                    do {
                        if let Json = try JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSArray{
                            block(Json)
                        }
                    }
                    catch let error{
                        print(error.localizedDescription)
                    }
                }
            }
        }
        task.resume()
    }
}
