//
//  ContentView.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @FetchRequest(
        //V-73, Paso 4 , ordenaremos los pokemon por el id, \Pokemon.id
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        animation: .default)
    //Paso 5,le ponemos Pokemon
    private var pokedex: FetchedResults<Pokemon>
    
    //Vid 98
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    )private var favorites: FetchedResults<Pokemon>
    
    @State var filterByFavorites = false
    //Vid 96
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    var body: some View {
        //Vid 96, embebemos
        switch pokemonVM.status {
        case .success:
            NavigationStack {
                //Vid 91,(pokedex)
                List (filterByFavorites ?  favorites : pokedex) { pokemon in
                    NavigationLink(value: pokemon ) {
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        }placeholder: {
                            ProgressView()
                        }
                        .frame(width: 100,height: 100)
                        //Paso 6,ponemos en mayúscula el nombre del pokemon
                        Text(pokemon.name!.capitalized)
                        
                        if pokemon.favorite{
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                    }
                }
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self , destination: { pokemon in
                    //Vid 95
                    PokemonDetail()
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        //Vid 98
                        Button {
                            withAnimation{
                                filterByFavorites.toggle()
                            }
                        }label: {
                            Label("Filter By Favorites", systemImage: filterByFavorites ? "star.fill" : "star")
                        }
                        .font(.title)
                        .foregroundColor(.yellow)
                    }
                }
            }
        default:
            ProgressView()
        }
    }
}



#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
