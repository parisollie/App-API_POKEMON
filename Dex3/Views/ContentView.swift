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
    
    //V-84,Paso 61,favorites
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pokemon.id, ascending: true)],
        //solo haces fetch con los favoritos.
        predicate: NSPredicate(format: "favorite = %d", true),
        animation: .default
    )private var favorites: FetchedResults<Pokemon>
    
    @State var filterByFavorites = false
    //V-82,Paso 54
    @StateObject private var pokemonVM = PokemonViewModel(controller: FetchController())
    
    var body: some View {
        //Paso 55, embebemos en un switch
        switch pokemonVM.status {
            
        case .success:
            //Paso 32, ponemos el NavigationStack
            NavigationStack {
                //V-77,Paso 29, ponemos (pokedex)
                //Paso 63, los filtraremos por favoritos
                List (filterByFavorites ?  favorites : pokedex) { pokemon in
                    //Paso 30, ponemos el value: pokemon
                    NavigationLink(value: pokemon) {
                        //Paso 31, pondremos la imagen del pokemon
                        AsyncImage(url: pokemon.sprite) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        }placeholder: {
                            ProgressView()
                        }
                        //Hacemos la imagen mas pequeña
                        .frame(width: 100,height: 100)
                        //Paso 6,ponemos en mayúscula el nombre del pokemon
                        Text(pokemon.name!.capitalized)
                        //Paso 64
                        if pokemon.favorite{
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }
                        
                    }
                }
                //Paso 33 ponemos el title
                .navigationTitle("Pokedex")
                .navigationDestination(for: Pokemon.self , destination: { pokemon in
                    //Paso 53,Hacia donde viajaremos.
                    PokemonDetail()
                    //Hacia el pokemon que viajaremos
                        .environmentObject(pokemon)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        //Paso 62, boton de favoritos.
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
