//
//  WidgetPokemon.swift
//  Dex3
//
//  Created by Paul F on 07/11/24.
//

import SwiftUI
//V-85,Paso 68, creamos la pagina de los widgets
enum WidgetSize{
    case small,medium,large
}

struct WidgetPokemon: View {
    //Pasp 69
    @EnvironmentObject var pokemon:Pokemon
    let widgetSize:WidgetSize
    var body: some View {
        
        ZStack{
            //Paso 70,Ponemos el color del widget
            Color(pokemon.types![0].capitalized)
            
            switch widgetSize{
                //Creo los tamaños de los widgets
            case .small:
                FetchedImage(url:pokemon.sprite)
            case .medium:
                HStack{
                    FetchedImage(url:pokemon.sprite)
                    
                    VStack(alignment: .leading){
                        Text(pokemon.name!.capitalized)
                            .font(.title)
                        Text(pokemon.types!.joined(separator: ", ").capitalized)
                    }
                    .padding(.trailing,30)
                }
            case .large:
                FetchedImage(url: pokemon.sprite)
                VStack{
                    HStack{
                        Text(pokemon.name!.capitalized)
                            .font(.largeTitle)
                        Spacer()
                    }
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        Text(pokemon.types!.joined(separator:", ").capitalized)
                            .font(.title2)
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    //Aqui cambiamos el tamaño de los widgets para visualizarlo
    WidgetPokemon(widgetSize:.medium)
        .environmentObject(SamplePokemon.samplePokemon)
}
