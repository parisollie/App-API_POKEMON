//
//  TempPokemon.swift
//  Dex3
//
//  Created by Paul F on 06/11/24.
//

import Foundation
//V-74,Paso 7, creamos la estructura de pokémon.-Ver el Video como hace la API-
struct TempPokemon: Codable{
    let id: Int
    let name: String
    let types: [String]
    //Paso 16, le ponemos 0, porque debemos inicializarlo ,por eso le puse var porque despues cambaira el valor
    var hp = 0
    var attack = 0
    var defense  = 0
    var specialAttack = 0
    var specialDefense  = 0
    var speed  = 0
    let sprite: URL
    let shiny: URL
    
    //Paso 8, creamos el enum construye una estructura de nuestro Json usando las keys
    enum PokemonKeys: String, CodingKey{
        
        case id
        case name
        case types
        case stats
        case sprites
        
        //Paso 9,Hacemos esto porque debemos bajar otros niveles en la API
        enum TypeDictionaryKeys: String, CodingKey{
            
            case type
            
            enum TypeKeys: String, CodingKey{
                //Bajamos otro nive en la API
                case name
            }
        }
        
        enum StatDictionaryKeys: String, CodingKey{
            
            //Ponemos el Key de la API,"base_stat"
            case value = "base_stat"
            case stat
            
            enum StatKeys: String, CodingKey{
                case name
            }
        }
        
        enum SpriteKeys: String, CodingKey{
            
            case sprite = "front_default"
            case shiny = "front_shiny"
        }
    }
    
    //Paso 10, debemos hacer un init despues de que hicimos el paso 9
    init (from decoder: Decoder) throws {
        //Usamos los containers que tienen la data
        let container = try decoder.container(keyedBy: PokemonKeys.self)
        
        //Empezaos con los valores
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        //Paso 11
        var decodedTypes: [String] = []
        //creamos un conteiner porque queremos ir mas produndo.
        var typeContainer = try container.nestedUnkeyedContainer(forKey: .types)
        //Mientras no termine (!typeContainer.isAtEnd) keep looping true
        while !typeContainer.isAtEnd{
            
            let typesDictionaryContainer = try typeContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.self)
            //Recordar que debemos ir mas adentro, revisar el video para la explicacion mas clara.
            let TypeContainer = try typesDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.TypeDictionaryKeys.TypeKeys.self, forKey: .type)
            //con apprend lo agregamos al arreglo [] que teniamos vacío.
            let type = try TypeContainer.decode(String.self, forKey: .name)
            decodedTypes.append(type)
        }
        //Paso 12, finalmente asiganmos el decodedTypes que creamos en el paso 11
        types = decodedTypes
        
        //Paso 13
        var statsContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        //Haremos lo mismo que arriba un WhileLoop
        while !statsContainer.isAtEnd{
            
            let  statsDictionaryContainer = try statsContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.self)
            let statContainer = try statsDictionaryContainer.nestedContainer(keyedBy: PokemonKeys.StatDictionaryKeys.StatKeys.self, forKey: .stat)
            
            //Paso 14, creamos un switch, todos estos valores estan en el stat container de la API
            switch try statContainer.decode(String.self, forKey: .name){
                
            case "hp":
                hp = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "attack":
                attack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "defense":
                defense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-attack":
                specialAttack = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "special-defense":
                specialDefense = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            case "speed":
                speed = try statsDictionaryContainer.decode(Int.self, forKey: .value)
            
            default:
                print("It will never  get here so...")
                
            }
        }
        //Paso 15, hacemos el container de los shynis
        let spriteContainer = try container.nestedContainer(keyedBy: PokemonKeys.SpriteKeys.self, forKey: .sprites)
        sprite = try spriteContainer.decode(URL.self,forKey: .sprite)
        shiny = try spriteContainer.decode(URL.self,forKey: .shiny)
    }
}
