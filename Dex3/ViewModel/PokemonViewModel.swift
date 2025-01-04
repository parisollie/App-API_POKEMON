//
//  PokemonViewModel.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

//V-75,paso 25, se parece a la breaking bad, no explica mucho ver elbreaking bad 
import Foundation

@MainActor
class PokemonViewModel: ObservableObject {
    
    enum Status {
        
        case notStarted
        case fetching
        case success
        case failed(error : Error)
    }
    
    @Published private(set) var status = Status.notStarted
    
    private let controller: FetchController
    
    init(controller: FetchController) {
        self.controller = controller
        
        //Paso 28, creamos el Task
        Task{
            await getPokemon()
        }
    }
    //Paso 27,creamos la funcion
    private func getPokemon() async {
        status = .fetching
        
        do {
            //Paso 60
            guard var pokedex = try await controller.fetchAllPokemon() else {
                print("Pokemon have already been got. We good.")
                status = .success
                return
            }
            //Los ordenamos
            pokedex.sort {$0.id < $1.id}
            //Vamos por cada uno de los pokemons
            for pokemon in pokedex {
                let newPokemon = Pokemon(context: PersistenceController.shared.container.viewContext)
                //Agregamos las propiedades
                newPokemon.id = Int16(pokemon.id)
                newPokemon.name = pokemon.name
                newPokemon.types = pokemon.types
                //Paso 57,organizeTypes()
                newPokemon.organizeTypes()
                newPokemon.hp = Int16(pokemon.hp)
                newPokemon.attack = Int16(pokemon.attack)
                newPokemon.defense = Int16(pokemon.defense)
                newPokemon.specialAttack = Int16(pokemon.specialAttack)
                newPokemon.specialDefense = Int16(pokemon.specialDefense)
                newPokemon.speed = Int16(pokemon.speed)
                newPokemon.sprite = pokemon.sprite
                newPokemon.shiny = pokemon.shiny
                newPokemon.favorite = false
                
                try PersistenceController.shared.container.viewContext.save()
                
            }
            status = .success
        }catch{
                status = .failed(error: error)
              }
        }
}

