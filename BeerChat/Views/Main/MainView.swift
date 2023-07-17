//
//  MainView.swift
//  BeerChat
//
//  Created by Jun on 2023/07/15.
//

import SwiftUI

struct MainView: View {
    @State var isMatching: Bool = false
    @State var matchingUser: User?
    @StateObject var firestoreManager: FirestoreManager = FirestoreManager()
    
    var body: some View {
        NavigationStack {
            TabView {
                MatchingView(isMatching: $isMatching, matchingUser: $matchingUser)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Main")
                    }
                    .onChange(of: isMatching) { newValue in
                        if !newValue {
                            matchingUser = nil
                        }
                    }
                    .fullScreenCover(isPresented: $isMatching) {
                        if let matchingUser = self.matchingUser {
                            MatchingProfileView(user: matchingUser, isPresentedSheet: $isMatching)
                                .environmentObject(firestoreManager)
                        }
                    }
                ChatListView()
                    .environmentObject(firestoreManager)
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
            .onAppear {
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
