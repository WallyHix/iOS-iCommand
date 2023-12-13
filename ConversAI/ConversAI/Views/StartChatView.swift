//
//  StartChatView.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 3.06.2023.
//

import SwiftUI

struct StartChatView: View {
    @StateObject private var viewModel = StartChatViewModel()
    
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    
    @EnvironmentObject var upgradeViewModel: UpgradeViewModel

    @State private var isPresented = false
    @State var showSuccessToast = false
    @State var showErrorToast = false
    
    var body: some View {
        
        ZStack {
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                AppBar().padding(.horizontal,20)
                ScrollView(.vertical,showsIndicators: false){
                    VStack(alignment: .center,spacing: 20) {
                        Spacer().frame(height: 30)
                        Image("AppVectorIcon")
                            .resizable().scaledToFill()
                            .frame(width: 180, height: 180)
                            .foregroundColor(.green_color)
                        
                        VStack(alignment: .center,spacing: 0) {
                            
                            if upgradeViewModel.isSubscriptionActive
                            {
                                HStack(alignment: .center,spacing: 5) {
                                    Text( "app_name".localize(language)).modifier(UrbanistFont(.bold, size: 35))
                                        .foregroundColor(Color.text_color)
                                    
                                    Text("pro".localize(language)).modifier(UrbanistFont(.bold, size: 30))
                                        .foregroundColor(Color.green_color).padding(.horizontal,10).padding(.vertical,1).background(Color.green_color.opacity(0.2)).cornerRadius(99, corners: .allCorners)
                                }
                            }else
                            {
                                Text( "welcome_to".localize(language)).modifier(UrbanistFont(.bold, size: 35))
                                    .foregroundColor(Color.text_color)
                                
                                Text("welcome_app_name".localize(language)).modifier(UrbanistFont(.bold, size: 35))
                                    .foregroundColor(Color.green_color).padding(.top, 5)
                            }
                            
                  
                            
                
                        }.padding(.top, 26)
                        
                        Text("welcome_description".localize(language)).modifier(UrbanistFont(.regular, size: 17)).multilineTextAlignment(.center)
                            .foregroundColor(Color.text_color).padding(.top, 5)
                        
                        NavigationLink(destination: ChatView(role: Constants.DEFAULT_AI), label: {
                            
                            Text("start_chat".localize(language)).modifier(UrbanistFont(.bold, size: 16)).foregroundColor(.white) .frame(height: 55).frame(maxWidth: .infinity)
                                .shimmer(config: .init(tint: .white, highlight: .white.opacity(0.8),blur : 10))
                                .background(Color.green_color).cornerRadius(99)
                                .padding(.top, 35).shadow(color: .black.opacity(0.2),radius: 6, x: 0, y: 6)
                            
                        }).buttonStyle(BounceButtonStyle())
                        
                        
                    }.frame(maxHeight:.infinity).padding(.horizontal,20)
                }
                
            }.frame(maxHeight:.infinity).padding(.bottom,5)
        }.onAppear{
            if UserDefaults.isFirstTime && !UserDefaults.isProVersion
            {
                isPresented.toggle()
                UserDefaults.isFirstTime = false
            }
        
        }
        .fullScreenCover(isPresented: $isPresented){
            UpgradeView(showSuccessToast: $showSuccessToast, showErrorToast: $showErrorToast)
        }.popup(isPresented: $showSuccessToast) {
            HStack(alignment: .center){
             
                    Text("welcome_to_pro_version".localize(language)).modifier(UrbanistFont(.semi_bold, size: 20)).multilineTextAlignment(.center)
                        .foregroundColor(Color.text_color)
                    
                }.padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
                    .frame(maxWidth: .infinity,alignment : .center).background(Color.green_color)

                    
        } customize: {
            $0
                .type (.toast)
                .position(.top)
                .animation(.spring())
                .closeOnTapOutside(true)
                .dragToDismiss(true)
        }
        .popup(isPresented: $showErrorToast) {
            HStack(alignment: .center){
             
                    Text("pro_version_not_purchased".localize(language)).modifier(UrbanistFont(.semi_bold, size: 20)).multilineTextAlignment(.center)
                        .foregroundColor(Color.text_color)
                    
                }.padding(EdgeInsets(top: 56, leading: 16, bottom: 16, trailing: 16))
                    .frame(maxWidth: .infinity,alignment : .center).background(Color.red_color)

                    
        } customize: {
            $0
                .type (.toast)
                .position(.top)
                .animation(.spring())
                .closeOnTapOutside(true)
                .dragToDismiss(true)
        }
        
    }
    
}

struct StartChatView_Previews: PreviewProvider {
    static var previews: some View {
        StartChatView()
    }
}
