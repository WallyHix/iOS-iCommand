//
//  ChatView.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 4.06.2023.
//

import SwiftUI
import Combine
import PopupView

struct ChatView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @StateObject var viewModel = ChatViewModel()
    @State var typingMessage: String = ""
    var name : String = "app_name"
    var role : String
    @State var conversationId : String = ""
    var examples : [String]?
    @FocusState private var fieldIsFocused: Bool
    @State  var paddingBottom : CGFloat = 0.0
    var rewardAd: RewardedAd = RewardedAd()
    @State private var isPresented = false

    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    
    @EnvironmentObject var upgradeViewModel: UpgradeViewModel
    @State var showSuccessToast = false
    @State var showErrorToast = false
    var body: some View {
        NavigationView {
            ZStack {
                Color.background.edgesIgnoringSafeArea(.all)
                VStack(alignment: .leading, spacing: 0) {
                    ZStack {
                        HStack{
                            Spacer()
                            
                            HStack(spacing: 10){
                                if !upgradeViewModel.isSubscriptionActive {
                                    Image("AppVectorIcon")
                                        .resizable().scaledToFill()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(.green_color)
                                }
                         
                                
                                Text(upgradeViewModel.isSubscriptionActive ? "PRO" : String(viewModel.freeMessageCount)).modifier(UrbanistFont(.bold, size: 20)).multilineTextAlignment(.center)
                                    .foregroundColor(Color.green_color)
                            }.padding(.horizontal,10).background(Color.green_color.opacity(0.2)).cornerRadius(10, corners: .allCorners).padding(.trailing, 20)
                            
                        }
                        
                        AppBar(imageName: "ArrowLeft", title: name,isDefault: false, onBack:  {
                            viewModel.stopGenerate()
                            self.presentationMode.wrappedValue.dismiss()
                        }).padding(.horizontal,20)
                        
                    }
                    ZStack {
                        
                        if viewModel.messages.isEmpty && !viewModel.showAdsAndProVersion {
                            if examples == nil {
                                Capabilities()
                            }else
                            {
                                Examples(typingMessage: $typingMessage, examples: examples!)
                            }
                        }else
                        {
                            MessageList(messages: viewModel.messages).padding(.bottom,paddingBottom)
                        }
                        VStack{
                            Spacer()
                            if  viewModel.isGenerating
                            {
                                StopButton(onClick: {
                                    viewModel.stopGenerate()
                                }).transition(.move(edge: .bottom))
                            }
                            
                            if  viewModel.showAdsAndProVersion
                            {
                                AdsAndProVersion(onClickWatchAd: {
                                    self.conversationId =   viewModel.conversationId
                                    _ = self.rewardAd.showAd {
                                        viewModel.showAdsAndProVersion = false
                                        viewModel.increaseFreeMessageCount()
                                        self.rewardAd.load()
                                    }
                                },onClickUpgrade: {
                                    self.conversationId =   viewModel.conversationId
                                    isPresented = true
                                }).transition(.move(edge: .bottom))
                            }
                            
                        }.frame(maxHeight:.infinity)
                        
                        
                    }.frame(maxHeight:.infinity)
                    
                    
                    VStack(spacing: 0)
                    {
                        Divider().frame(height: 2)
                        Spacer().frame(height: 15)
                        HStack(alignment: .bottom,spacing: 15) {
                            
                            TextField("ask_me_anything".localize(language), text: $typingMessage,axis: .vertical)
                                .focused($fieldIsFocused)
                                .lineLimit(5)
                                .padding(15)
                                .background(fieldIsFocused ? Color.green_color.opacity(0.2) : Color.gray_color ).cornerRadius(16)
                                .overlay(content: {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(
                                            Color.green_color, lineWidth: fieldIsFocused ? 1.5 : 0
                                        )
                                })
                                .modifier(UrbanistFont(.medium, size: 16))
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .onTapGesture {
                                    fieldIsFocused = true
                                }
                            
                            Button {
                                sendMessage()
                            } label: {
                                Image("Send")
                                    .resizable().scaledToFill()
                                    .frame(width: 25, height: 25)
                                
                            }  .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                                .background(Color.green_color).cornerRadius(99)
                            
                        }.padding(.bottom,20).padding(.horizontal,20)
                            .onDisappear {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
                            }
                    }.background(Color.background)
                    
                    
                    
                }.frame(maxHeight:.infinity)
                
            }.frame(maxHeight: .infinity)
                .onAppear{
                viewModel.role = self.role
                viewModel.conversationId = self.conversationId
                viewModel.removeHistory()
                viewModel.getMessagesHistory()
                viewModel.getFreeMessageCount()
            }
            .fullScreenCover(isPresented: $isPresented){
                UpgradeView(showSuccessToast: $showSuccessToast, showErrorToast: $showErrorToast)
            }
            .popup(isPresented: $showSuccessToast) {
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

            .onReceive(Publishers.CombineLatest(viewModel.$isGenerating, viewModel.$showAdsAndProVersion)) { isGenerating, showAdsAndProVersion in
                withAnimation {
                    if isGenerating {
                        paddingBottom = 80.0
                    } else if showAdsAndProVersion {
                        paddingBottom = 160.0
                    } else {
                        paddingBottom = 0.0
                    }
                }
            }
            .onReceive(upgradeViewModel.$isSubscriptionActive) { isSubscriptionActive in
                withAnimation {
                    if isSubscriptionActive
                    {
                        viewModel.showAdsAndProVersion = false
                    }
                }
            }
            .onChange(of: self.conversationId) { newDate in
                viewModel.conversationId = self.conversationId
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    private func sendMessage() {
        
        
        if !viewModel.isGenerating {
            guard !typingMessage.isEmpty else { return }
            if !upgradeViewModel.isSubscriptionActive {
                if viewModel.freeMessageCount > 0 {
                    viewModel.decreaseFreeMessageCount()
                } else
                {
                    withAnimation {
                        viewModel.showAdsAndProVersion = true
                    }
                    return
                }
            }
            
            let tempMessage = typingMessage
            typingMessage = ""
            hideKeyboard()
            Task{
                await viewModel.getResponse(text: tempMessage)
            }
            
        }
        
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


struct AdsAndProVersion : View
{
    var onClickWatchAd : () -> Void = {}
    var onClickUpgrade : () -> Void = {}
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    var body: some View {
        VStack(spacing: 0){
            Text("you_reach_free_message_limit".localize(language)).modifier(UrbanistFont(.medium, size: 14)).foregroundColor(.inactive_input).padding(10).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                .background(Color.red_shadow).cornerRadius(14)
                .padding(.horizontal, 10).padding(.top,10)
            
            HStack(spacing: 10){
                Button {
                    onClickUpgrade()
                } label: {
                    HStack(alignment: .center,spacing: 20) {
                        
                        Image("Star")
                            .resizable().scaledToFill()
                            .frame(width: 25, height: 25)
                            .foregroundColor( .green_color )
                        
                        Text("upgrade_to_pro".localize(language)).modifier(UrbanistFont(.bold, size: 14)).multilineTextAlignment(.leading)
                            .foregroundColor(Color.inactive_input)
                        
                    }.padding(.horizontal,15).frame(height: 60, alignment: .center).frame(maxWidth: .infinity)
                        .background(   Color.light_gray )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.card_border, lineWidth: 2)
                        ).padding(.vertical,10).padding(.leading,10)
                }.buttonStyle(BounceButtonStyle())
                
                Button {
                    onClickWatchAd()
                } label: {
                    HStack(alignment: .center,spacing: 20) {
                        
                        Image("Video")
                            .resizable().scaledToFill()
                            .frame(width: 25, height: 25)
                            .foregroundColor( .green_color )
                        
                        Text("watch_ad".localize(language)).modifier(UrbanistFont(.bold, size: 14)).multilineTextAlignment(.leading)
                            .foregroundColor(Color.inactive_input)
                        
                    }.padding(.horizontal,15).frame(height: 60, alignment: .center).frame(maxWidth: .infinity)
                        .background(   Color.light_gray )
                        .cornerRadius(16)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.card_border, lineWidth: 2)
                        ).padding(.vertical,10).padding(.trailing,10)
                }.buttonStyle(BounceButtonStyle())
            }
        }.padding(.horizontal,10)
        
        
        
    }
}

struct StopButton : View
{
    var onClick : () -> Void = {}
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    var body: some View {
        
        Button {
            onClick()
        } label: {
            HStack(alignment: .center,spacing: 10) {
                VStack{
                    
                }
                .frame(width: 25, height: 25)
                .background(Color.green_color)
                .cornerRadius(6, corners: .allCorners)
                
                Text("stop_generating".localize(language)).modifier(UrbanistFont(.bold, size: 16)).multilineTextAlignment(.center)
                    .foregroundColor(Color.inactive_input)
                
            }.padding(.horizontal,15).frame(height: 60, alignment: .center)
                .background(   Color.light_gray )
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.card_border, lineWidth: 2)
                ).padding(10)
        }.buttonStyle(BounceButtonStyle())
        
    }
}


struct Capabilities : View
{
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .center,spacing: 15) {
                Spacer().frame(height: 30)
                Image("AppVectorIcon")
                    .resizable().scaledToFill()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.inactive_input)
                
                Text( "capabilities".localize(language)).modifier(UrbanistFont(.bold, size: 20))
                    .foregroundColor(Color.inactive_input)
                
                
                Text("capabilities_1".localize(language)).modifier(UrbanistFont(.medium, size: 14)).foregroundColor(.inactive_input).padding(20).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                    .background(Color.light_gray).cornerRadius(14)
                    .padding(.horizontal, 20)
                
                Text("capabilities_2".localize(language)).modifier(UrbanistFont(.medium, size: 14)).foregroundColor(.inactive_input).padding(20).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                    .background(Color.light_gray).cornerRadius(14)
                    .padding( .horizontal, 20)
                Text("capabilities_3".localize(language)).modifier(UrbanistFont(.medium, size: 14)).foregroundColor(.inactive_input).padding(20).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                    .background(Color.light_gray).cornerRadius(14)
                    .padding(.horizontal, 20)
                
                Text("capabilities_desc".localize(language)).modifier(UrbanistFont(.medium, size: 14)).multilineTextAlignment(.center)
                    .foregroundColor(Color.inactive_input).padding(.top, 5)
                
            }
        }.frame(maxHeight:.infinity,alignment: .top).onAppear {
            UIScrollView.appearance().keyboardDismissMode = .interactive
        }
        
    }
}

struct Examples : View
{
    @Binding var typingMessage: String
    var examples : [String]
    @AppStorage("language")
    private var language = LanguageManager.shared.selectedLanguage
    var body: some View {
        GeometryReader { geometry in
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center,spacing: 15) {
                    Spacer().frame(height: 30)
                    
                    
                    Text( "type_something_like".localize(language)).modifier(UrbanistFont(.bold, size: 20))
                        .foregroundColor(Color.inactive_input)
                    
                    ForEach(examples, id: \.self) { example in
                        Button {
                            typingMessage = example.localize(language)
                        } label: {
                            Text(example.localize(language)).modifier(UrbanistFont(.medium, size: 14)).foregroundColor(.inactive_input).padding(20).frame(maxWidth: .infinity).multilineTextAlignment(.center)
                                .background(Color.light_gray).cornerRadius(14)
                                .padding(.horizontal, 20)
                        }.buttonStyle(BounceButtonStyle())
                        
                        
                    }
                } .frame(width: geometry.size.width)
                    .frame(minHeight: geometry.size.height)
                
                
                
            }.frame(maxHeight:.infinity,alignment: .center).onAppear {
                UIScrollView.appearance().keyboardDismissMode = .interactive
            }
            
        }
    }
}

struct MessageList : View
{
    @Namespace var bottomID
    
    
    var messages : [MessageModel]
    var body: some View {
        
        ScrollViewReader { reader in
            ScrollView(.vertical, showsIndicators: false) {
                
                LazyVStack {
                    ForEach(messages) { message in
                        
                        LazyView( MessageCard(message: message))
                    }
                    Text("").id(bottomID)
                }.padding(.horizontal, 16)
                
            }.frame(maxHeight:.infinity)
                .onChange(of: messages.last?.content as? String) { _ in
                    DispatchQueue.main.async {
                        withAnimation {
                            reader.scrollTo(bottomID)
                        }
                    }
                }
                .onChange(of: messages.count) { _ in
                    withAnimation {
                        reader.scrollTo(bottomID)
                    }
                }
                .onAppear {
                    withAnimation {
                        reader.scrollTo(bottomID)
                    }
                    UIScrollView.appearance().keyboardDismissMode = .interactive
                    
                }
        }.frame(maxHeight:.infinity,alignment: .top)
    }
}
//
//struct ChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatView(role: "",examples: ["write_article_example1","write_article_example2","write_article_example3"])
//    }
//}
