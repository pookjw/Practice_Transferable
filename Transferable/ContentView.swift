//
//  ContentView.swift
//  Transferable
//
//  Created by Jinwoo Kim on 11/7/22.
//

import SwiftUI
import CoreTransferable

struct ContentView: View {
    @State var myColor: MyColor = .init(r: 0.3, g: 0.5, b: 0.3)
    
    var body: some View {
        Color(myColor: myColor)
            .onDrag {
                let itemProvider: NSItemProvider = .init()
                itemProvider.register(myColor)
                return itemProvider
            }
            .onDrop(of: [.json], isTargeted: nil) { providers in
                guard let firstProvider: NSItemProvider = providers.first else {
                    return false
                }
                
                let _: Progress = firstProvider.loadTransferable(type: MyColor.self) { result in
                    switch result {
                    case .success(let myColor):
                        self.myColor = myColor
                    case .failure(let failure):
                        fatalError(failure.localizedDescription)
                    }
                }
                
                return true
            }
    }
}

extension Color {
    init(myColor: MyColor) {
        let cgColor: CGColor = .init(
            red: CGFloat(myColor.r),
            green: CGFloat(myColor.g),
            blue: CGFloat(myColor.b),
            alpha: 1.0
        )
        
        self.init(cgColor: cgColor)
    }
}
