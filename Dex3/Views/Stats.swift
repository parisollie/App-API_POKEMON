//
//  Stats.swift
//  Dex3
//
//  Created by Paul F on 07/11/24.
//

import SwiftUI
import Charts
//V-81,Paso 49
struct Stats: View {
    //Paso 50,ponemos @EnvironmentObject
    @EnvironmentObject var pokemon: Pokemon
    var body: some View {
        //Usa los valores que creamos antes
        Chart(pokemon.stats){stat in
            BarMark(
                x: .value("Value",stat.value),
                y: .value("Stat",stat.label)
            )
            //Paso 51,ponemos la posicion de ls numeros al final 
            .annotation(position: .trailing){
                Text("\(stat.value)")
                    .padding(.top,-5)
                    .foregroundColor(.secondary)
                    .font(.subheadline)
            }
        }
        //Paso 51
        .frame(height: 200)
        .padding([.leading,.bottom, .trailing])
        //sacamos el color de los assets, pero del primer tipo del pokemon
        .foregroundColor(Color(pokemon.types![0].capitalized))
        .chartXScale(domain:0...pokemon.highestStat.value+5)
    }
}

#Preview {
    Stats()
        .environmentObject(SamplePokemon.samplePokemon)
}
