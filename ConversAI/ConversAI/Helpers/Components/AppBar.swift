//
//  AppBar.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 4.06.2023.
//

import SwiftUI

struct AppBar: View {
    var imageName : String = "AppVectorIcon"
    var title : String = "app_name"
    var isDefault : Bool = true
    var isHistoryAppBar : Bool = false
    var onBack: () -> Void = { }
    var onSearch: () -> Void = { }
    var onDelete: () -> Void = { }
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    var body: some View {
        ZStack{
            Text(title.localize(language)).modifier(UrbanistFont(.semi_bold, size: 20)).multilineTextAlignment(.center)
                .foregroundColor(Color.text_color).padding(.top, 4).frame(maxWidth:.infinity)
            
            HStack{
                Button {
                    onBack()
                } label: {
                    Image(imageName)
                        .resizable().scaledToFill()
                        .frame(width: 30, height: 30)
                        .foregroundColor(isDefault ? .green_color :  .text_color)
                }

                Spacer()
                
                if isHistoryAppBar
                {
                    HStack{
                        Button {
                            onSearch()
                        } label: {
                            Image("Search")
                                .resizable().scaledToFill()
                                .frame(width: 27, height: 27)
                                .foregroundColor(.text_color)
                        }
                        
                        Spacer().frame(width: 15)
                        
                        Button {
                            onDelete()
                        } label: {
                            Image("Delete")
                                .resizable().scaledToFill()
                                .frame(width: 27, height: 27)
                                .foregroundColor(.text_color)
                        }
                 
                    }
                }
                
            }
         
        }.frame(height: 55)
    }
}

struct AppBar_Previews: PreviewProvider {
    static var previews: some View {
        AppBar()
    }
}
