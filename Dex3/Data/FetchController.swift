//
//  FetchController.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

//V-75,paso 17, creamos el FetchController
import Foundation
//Paso 59,importamos core data
import CoreData

struct FetchController {
    //Paso 18 , creamos los errores en Network.
    enum NetworkError: Error {
        case badURL, badResponse,badData
    }
    //Paso 19, ponemos la URL  de la api
    private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
    
    /*Paso 20,ponems el async,retornaremos un TempoPokemon, haremos la funcion para checar la api
    Paso 59 ,ponemos el ?, opcional y retornamos el array del pokemon o nil*/
    func fetchAllPokemon() async throws -> [TempPokemon]? {
        
        //Paso 60
        if havePokemon(){
            return nil
        }
        
        //Paso 21,Creamos un array de TempPokemon
        var allPokemon: [TempPokemon] = []
        
        //https://pokeapi.co/api/v2/pokemon?limit=386
        var fetchComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)
        fetchComponents?.queryItems = [URLQueryItem(name: "limit", value: "386")]
        
        //Ponemos para asegurarnos que no falle, no dejes pasar este punto sino funciona
        guard let fetchURL = fetchComponents?.url else { throw NetworkError.badURL }
        
        //consigue los datos y la respuesta
        let (data,response) = try await URLSession.shared.data(from: fetchURL)
        
        //Checamos la respuesta y vemos si todo esta bien
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.badResponse }
        
        /*Paso 22 , creamos un diccionario todo los datos que obtuvimos lo convertiremos en un JSON
        de esta manera podremos trabajar con los datos,  [String:Any], puede ser cualquier valor any,
        para count, next ,previous and results,la palabra results viene de la pokeapi , ver el video*/
        guard let pokeDictionary = try JSONSerialization.jsonObject(with: data) as? [String:Any],let pokedex = pokeDictionary["results"] as? [[String:String]] else { throw NetworkError.badData
        }
        //Paso 24,regresamos cada pokemon 
        for pokemon in pokedex {
            if let  url = pokemon["url"] {
                allPokemon.append(try await fetchPokemon(from: URL(string: url)!))
            }
        }
           
        //Regresamos todos los pokemos
        return allPokemon
    }
    //Paso 23,esta funcion nos regresará un pokemon con todo los detalles que queremos
    private func fetchPokemon(from url:URL) async throws ->TempPokemon {
        
        let(data,response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw NetworkError.badResponse
        }
        //Regresamos la informacion en Json
        let tempPokemon = try JSONDecoder().decode(TempPokemon.self,from: data)
        //Imprimimos en la consola
        print("Fetched \(tempPokemon.id): \(tempPokemon.name)")
        
        return tempPokemon
    }
    
    //V-83,Paso 58, ver Video para ver la explicacion mejor.
    
    private func havePokemon() -> Bool {
        
        let context = PersistenceController.shared.container.newBackgroundContext()
        
        let fetchRequest: NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        //quiero hacer fetch el pokemon con el id 1 y 386
        fetchRequest.predicate = NSPredicate(format: "id IN %@",[1,386])
        
        do{
            let checkPokemon = try context.fetch(fetchRequest)
            
            if checkPokemon.count == 2{
                return true
            }
        }catch{
            print("Fetch failed: \(error)")
            return false
            
        }
        return false
    }
}

