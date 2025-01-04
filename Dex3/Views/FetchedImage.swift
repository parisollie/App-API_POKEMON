//
//  FetchedImage.swift
//  Dex3
//
//  Created by Paul F on 07/11/24.
//

import SwiftUI
//V-85,paso 67
struct FetchedImage: View {
    //Los URL , siempre son opcional
    let url: URL?
    var body: some View {
        if let url,let imageData = try?Data(contentsOf: url),let uiImage = UIImage(data: imageData){
            Image(uiImage : uiImage)
                .resizable()
                .scaledToFit()
                .shadow(color: .black, radius:8)
        }else{
            //Traemos la imagen de los assets
            Image("bulbasaur")
        }
    }
}

#Preview {
    FetchedImage(url: SamplePokemon.samplePokemon.sprite)
}
