//
//  AssistantsView.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 4.06.2023.
//

import SwiftUI

struct AssistantsView: View {
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage

    @StateObject var viewModel = AssistantsViewModel()
    let columns = [
           GridItem(.flexible()),
           GridItem(.flexible())
       ]
    var body: some View {
        
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading,spacing: 0) {
                AppBar(title: "ai_assistants").padding(.trailing,20)
                VStack(alignment: .leading,spacing: 0) {
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: 6) {
                            ChipItem(text: "all",selected: viewModel.selectedValue == ""){
                                viewModel.selectedValue = ""
                                viewModel.showVertical = false
                            }
                            ForEach(viewModel.assistantList) { item in
                                ChipItem(text: item.title,selected: viewModel.selectedValue == item.title){
                                    viewModel.selectedValue = item.title
                                    viewModel.verticalShowList.removeAll()
                                    viewModel.verticalShowList = item.assistant
                                    viewModel.showVertical = true
                                }
                                
                            }
                        }
                    }.padding(.bottom,5).padding(.vertical,5)
                    
                    if (viewModel.showVertical) {
                        ScrollView(.vertical, showsIndicators: false) {
                            LazyVGrid(columns: columns,spacing: 10) {
                                ForEach(viewModel.verticalShowList) { assistant in
                                    AssistantCard(image: assistant.image, color: assistant.color, name: assistant.name, description: assistant.description,role: assistant.role, examples: assistant.example, isVertical : true)
                                      
                                    
                                }
                            }
                        }.frame(maxHeight: .infinity).padding(.trailing,20)
                        
                    }else
                    {
                        ScrollView(.vertical, showsIndicators: false) {
                         
                                ForEach(viewModel.assistantList) { item in
                                    
                                    HStack{
                                        Text(item.title.localize(language)).modifier(UrbanistFont(.bold, size: 20)).multilineTextAlignment(.leading)
                                            .foregroundColor(Color.text_color).padding(.top, 4)
                                        
                                        Spacer()
                                        
                                        Button {
                                            viewModel.selectedValue = item.title
                                            viewModel.verticalShowList.removeAll()
                                            viewModel.verticalShowList = item.assistant
                                            viewModel.showVertical = true
                                        } label: {
                                            Image("ArrowRight")
                                                .resizable().scaledToFill()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.green_color)
                                        }.padding(.trailing,20)
                                    }.padding(.vertical,10)
                                    
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            ForEach(item.assistant) { assistant in
                                                AssistantCard(image: assistant.image, color: assistant.color, name: assistant.name, description: assistant.description,role: assistant.role, examples: assistant.example, isVertical: false)
                                                
                                            }
                                        }
                                    }
                                }
                            
                            
                        }.frame(maxHeight: .infinity)
                    }
                   
                    
                }.frame(maxHeight:.infinity)
            }.frame(maxHeight:.infinity).padding(.leading,20).padding(.bottom,5)
            
        }
        
    }
}

struct AssistantsView_Previews: PreviewProvider {
    static var previews: some View {
        AssistantsView()
    }
}
