//
//  BottomNav.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 4.06.2023.
//

import Foundation
import SwiftUI

enum ScreensEnum: String, CaseIterable {
    case start_chat
    case ai_assistants
    case history
    case settings
    case chat
    
}

enum TabType: Int, CaseIterable {
    case start_chat = 0
    case assistants
    case history
    case settings
    
    var tabItem: TabItemData {
        switch self {
        case .start_chat:
            return TabItemData(image: "Chat", selectedImage: "ChatBold", title: "chat")
        case .assistants:
            return TabItemData(image: "Assistants", selectedImage: "AssistantsBold", title: "ai_assistants")
        case .history:
            return TabItemData(image: "History", selectedImage: "HistoryBold", title: "history")
        case .settings:
            return TabItemData(image: "Setting", selectedImage: "SettingBold", title: "settings")
        }
    }
}
struct CustomTabView: View {
    
    let tabs: [TabItemData]
    @Binding var selectedIndex: Int
    
    
    var body: some View {
        
    
        TabBottomView(tabbarItems: tabs, selectedIndex: $selectedIndex).background(Color.background)

    }
    
    
}



struct TabBottomView: View {
    
    let tabbarItems: [TabItemData]
    @Binding var selectedIndex: Int
    
    var body: some View {
        
        HStack {
            Spacer()
            
            ForEach(0..<tabbarItems.count, id: \.self) { index in
                let item = tabbarItems[index]
                Button {
                    self.selectedIndex = index
                } label: {
                    let isSelected = selectedIndex == index
                    TabItemView(data: item, isSelected: isSelected)
                }
                Spacer()
            }
        }.padding(.top,7)
        
        
    }
}

struct TabItemView: View {
    let data: TabItemData
    let isSelected: Bool
    
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    
    var body: some View {
        VStack {
            Image(isSelected ? data.selectedImage : data.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 25, height: 25)
                .foregroundColor(isSelected ? .green_color : .inactive_input)
            
            
            Spacer().frame(height: 4)
            
           Text( data.title.localize(language)).modifier(UrbanistFont(.medium, size: 11))
                .foregroundColor(isSelected ? .green_color : .inactive_input)
            
        }.frame(maxWidth: .infinity)
    }
}

struct TabItemData {
    let image: String
    let selectedImage: String
    let title: String
}



struct View_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
