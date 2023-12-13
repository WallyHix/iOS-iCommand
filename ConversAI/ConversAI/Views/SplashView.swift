//
//  SplashScreen.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 12.06.2023.
//

import SwiftUI

struct SplashView: View {
    @State var isActive: Bool = false
    
    var body: some View {
        ZStack {
            
            if self.isActive {
                ContentView()
            } else {
                
                Color.background.edgesIgnoringSafeArea(.all)
                
                Image("AppVectorIcon")
                    .resizable().scaledToFill()
                    .frame(width: 180, height: 180)
                    .foregroundColor(.green_color)
            }
            
            
            
        }.frame(maxHeight:.infinity)
            .onAppear {
                UserDefaults.isFirstTime = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation(.easeIn(duration: 1.0)) {
                        self.isActive = true
                    }
                }
            }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
