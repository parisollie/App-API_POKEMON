//
//  Pokemon+Ext.swift
//  Dex3
//
//  Created by Paul F on 07/11/24.
//

import Foundation
//Vid 94

extension Pokemon {
    var background: String {
        //self es de cualquier pokemon que hablemos lapras es laparas
        switch self.types![0]{
            
        case "normal","grass","electric","poison","fairy":
            return "normal"
        case "rock","ground","steel","fighting","ghost","dark","psychic":
            return "rock"
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
    
    var highestStat: Stat {
        stats.max(by: { $0.value < $1.value })!
    }
    
    //Vid 96
    func organizeTypes(){
        if self.types!.count == 2 && self.types![0] == "normal"{
            //cambiamos el primer tipo al segundo
            self.types!.swapAt(0,1)
        }
    }
}

struct Stat: Identifiable {
    let id : Int
    let label : String
    let value : Int16
}
