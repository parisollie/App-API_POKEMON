//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

import SwiftUI
import CoreData
//V-78,Paso 34,Creamos esta vista
struct PokemonDetail: View {
    //paso 35,creamos el @EnvironmentObject var pokemon: Pokemon
    @EnvironmentObject var pokemon: Pokemon
    //Paso 44, ponemos la variable para el shiny
    @State var showShiny = false
    //Paso 67, para los favoritos
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        //Vid 79,Paso 39, ponemos un ScrollView
        ScrollView{
            ZStack{
                //Paso 40, imagen del background del pokemon
                //Paso 45, ponemos el background
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black,radius: 6)
                //Paso 41, ponemos la imagen del pokémon
                //Paso 45, es shiny el pokemon  si lo es ponlo sino el normal, usamos if ternario
                AsyncImage(url:showShiny ? pokemon.shiny : pokemon.sprite) {image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top,50)
                        .shadow(color: .black,radius: 6)
                }placeholder: {
                    //Paso 42, ponemos el ProgressView
                    ProgressView()
                }
            }
            //Paso 41, ponemos los types de pokemon
            HStack{
                //Ponemos un For each para obtener todos los tipos y su identificable es el mismo y sabemos que son unicos
                ForEach(pokemon.types!, id:\.self){type in
                    Text(type.capitalized)
                        .font(.title2)
                        .padding([.top,.bottom],7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                //Paso 42,Este spacer empuja a los tipos irse a la iz quierda
                Spacer()
          
                Button {
                    //Paso 66
                    withAnimation{
                        pokemon.favorite.toggle()
                        
                        do {
                            try viewContext.save()
                        } catch {
                            let nsError = error as NSError
                            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                        }
                    }
                    
                }label: {
                    //V-84,Paso 65
                    if pokemon.favorite{
                        Image(systemName: "star.fill")
                    }else{
                        Image(systemName: "star")
                    }
                }
                .font(.largeTitle)
                .foregroundColor(.yellow)
            }
            .padding()
            
            //Vid 95
            Text("Stats")
                .font(.title)
                .padding(.bottom, -7)
            //Paso 52,Ponemos los stats
            Stats()
                .environmentObject(pokemon)
        }
        .ignoresSafeArea()
        //Paso 43
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
                //Paso 44, ponemos el boton para el shiny
                Button{
                    showShiny.toggle()
                }label:{
                    if showShiny{
                        Image(systemName: "wand.and.stars")
                            .foregroundColor(.yellow)
                    }else{
                        Image(systemName: "wand.and.stars.inverse")
                    }
                }
            }
        }
    }
}

#Preview {
    PokemonDetail()
        .environmentObject(SamplePokemon.samplePokemon)
}
