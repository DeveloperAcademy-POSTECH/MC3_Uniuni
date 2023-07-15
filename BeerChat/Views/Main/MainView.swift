//
//  MainView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/15.
//

import SwiftUI

struct MainView: View {
    var body: some View {
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
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
