//
//  MainView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/15.
//

import SwiftUI

struct MainView: View {
    @State var pageIndex: Int = 0
    @State var chatRoomId: String = ""
    
    var body: some View {
        NavigationStack {
            TabView(selection: $pageIndex) {
                MatchingView(chatRoomId: $chatRoomId, pageIndex: $pageIndex)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Main")
                    }
                    .tag(0)
                ChatListView(chatRoomId: $chatRoomId)
                    .tabItem {
                        Image(systemName: "message.fill")
                        Text("Chat")
                    }
                    .tag(1)
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My")
                    }
                    .tag(2)
            }
            .onAppear {
                UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(0.75)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
