//
//  Persistence.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    //V-70 , paso 1
    let container: NSPersistentContainer
    
    @MainActor
    static let preview: PersistenceController = {
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        //V-73,paso 3
        let samplePokemon = Pokemon(context: viewContext)
        //Ponemos el dato del pokemon que vamos a usar que es Bulbasaur de la API
        samplePokemon.id = 1
        samplePokemon.name = "bulbasaur"
        samplePokemon.types = ["grass","poison"]
        samplePokemon.hp = 45
        samplePokemon.attack = 49
        samplePokemon.defense = 49
        samplePokemon.specialAttack = 65
        samplePokemon.specialDefense = 65
        samplePokemon.speed = 45
        samplePokemon.sprite = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        samplePokemon.shiny = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/1.png")
        samplePokemon.favorite = false
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

  

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Dex3")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }else{
            //Vid 87,Paso 71-Widgets.
            container.persistentStoreDescriptions.first!.url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.pjff.Dex3Group")!.appending(path: "Dex3.sqlite")
        }
        
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
