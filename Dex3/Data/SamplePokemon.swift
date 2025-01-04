//
//  SamplePokemon.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

import Foundation
import CoreData

struct SamplePokemon {
    static let samplePokemon = {
        
        //Paso 37
        let context = PersistenceController.preview.container.viewContext

        let fetchRequest:NSFetchRequest<Pokemon> = Pokemon.fetchRequest()
        //garantizamos que solo sera un pokemon 
        fetchRequest.fetchLimit = 1
        
        let results = try! context.fetch(fetchRequest)
        
        //Regresamos el primer resultado que encuentres.
        return results.first!
    }()
}










