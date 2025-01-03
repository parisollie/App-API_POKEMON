//
//  PokemonDetail.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

import SwiftUI
import CoreData
//Vid 93
struct PokemonDetail: View {
    @EnvironmentObject var pokemon: Pokemon
    @State var showShiny = false
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ScrollView{
            ZStack{
                Image(pokemon.background)
                    .resizable()
                    .scaledToFit()
                    .shadow(color: .black,radius: 6)
                
                AsyncImage(url:showShiny ? pokemon.shiny : pokemon.sprite) {image in
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(.top,50)
                        .shadow(color: .black,radius: 6)
                }placeholder: {
                    ProgressView()
                }
            }
            
            
            HStack{
                ForEach(pokemon.types!, id:\.self){type in
                    Text(type.capitalized)
                        .font(.title2)
                        .padding([.top,.bottom],7)
                        .padding([.leading, .trailing])
                        .background(Color(type.capitalized))
                        .cornerRadius(50)
                }
                Spacer()
                
                Button {
                    //Vid 98
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
            Stats()
                .environmentObject(pokemon)
        }
        .ignoresSafeArea()
        .navigationTitle(pokemon.name!.capitalized)
        .toolbar{
            ToolbarItem(placement: .navigationBarTrailing){
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
