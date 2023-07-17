//
//  MainView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/15.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationStack {
            TabView {
                MatchingView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Main")
                    }
                ChatListView()
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My")
                    }
            }
            .onAppear() {
                UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(0.75)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(FirestoreManager())
    }
}
