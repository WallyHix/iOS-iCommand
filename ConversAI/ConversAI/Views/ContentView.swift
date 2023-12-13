//
//  ContentView.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 3.06.2023.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedIndex = 0

    @ObservedObject var viewModel  = ContentViewModel()
    @EnvironmentObject var upgradeViewModel: UpgradeViewModel

    var body: some View {
        NavigationView {
        
            ZStack(alignment: .bottom)
            {
                TabView(selection: $selectedIndex)
                {
                    StartChatView().tag(0)
                    AssistantsView().tag(1)
                    HistoryView().tag(2)
                    SettingsView().tag(3)
                }
               
                CustomTabView(tabs: TabType.allCases.map({ $0.tabItem }), selectedIndex: $selectedIndex )
                
                ZStack
                {
                    Rectangle()
                        .foregroundColor(Color.black)
                        .opacity(upgradeViewModel.isLoading ? 0.5: 0.0)
                        .edgesIgnoringSafeArea(.all)
                    
                    ProgressView()
                        .scaleEffect(2, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.green_color))
                    
                }.opacity(upgradeViewModel.isLoading ? 1: 0.0).edgesIgnoringSafeArea(.all)
           
            }
        
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
