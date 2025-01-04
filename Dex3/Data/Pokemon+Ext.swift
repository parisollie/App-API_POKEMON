//
//  Pokemon+Ext.swift
//  Dex3
//
//  Created by Paul F on 07/11/24.
//

import Foundation
//V-80, Paso 46 creamos este archivo de extension.
extension Pokemon {
    var background: String {
        //self es de cualquier pokemon que hablemos lapras es laparas
        switch self.types![0]{
            
        case "normal","grass","electric","poison","fairy":
            //Ponemos el nombre de la imagen en nuestros Assets
            return "normalgrasselectricpoisonfairy"
        case "rock","ground","steel","fighting","ghost","dark","psychic":
            return "rockgroundsteelfightingghostdarkpsychic"
        case "fire","dragon":
            return "firedragon"
        case "flying","bug":
            return "flyingbug"
        case "ice":
            return "ice"
        case "water":
            return "water"
        default :
            return "hi"
        }
    }
    //Paso 47, pondremos en orden lo que tenemos en el Dex3
    var stats: [Stat]{
        [
            Stat(id: 1, label:"HP",value: self.hp),
            Stat(id: 2, label:"Atttack",value:self.attack),
            Stat(id: 3, label:"Defense",value:self.defense),
            Stat(id: 4, label:"Special Attack",value:self.specialAttack),
            Stat(id: 5, label:"Special Defense",value:self.specialDefense),
            Stat(id: 6, label:"Speed",value:self.speed)
        ]
    }
    //Paso 48
    var highestStat: Stat {
        //Dame el valor mas alto,! sabemos que existe
        stats.max(by: { $0.value < $1.value })!
    }
    
    //V-82,Paso 56 si el primer tipo es normal cambialo
    func organizeTypes(){
        //Si ambos son verdaderos.
        if self.types!.count == 2 && self.types![0] == "normal"{
            //cambiamos el primer tipo al segundo
            self.types!.swapAt(0,1)
            
            /*Esta es otra forma mas complicada
             
            let tempType = self.types![0]
            self.types![0] = self.types![1]
            self.types![1] = tempType*/
        }
    }
}
//Paso 46,ponemos las propiedades que tenemos en el Dex3
struct Stat: Identifiable {
    let id : Int
    let label : String
    let value : Int16
}
