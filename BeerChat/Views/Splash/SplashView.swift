//
//  SplashView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/14.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Text("SplashView")
            Button("Next", action: {
                PageManager.shared.currentPage = .entry
            })
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
