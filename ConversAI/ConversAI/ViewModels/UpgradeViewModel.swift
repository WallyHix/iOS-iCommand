//
//  UpgradeViewModel.swift
//  ConversAI
//
//  Created by Murat ÖZTÜRK on 11.06.2023.
//

import Foundation
import SwiftUI
import RevenueCat


class UpgradeViewModel : ObservableObject{
  
    @Published var isSubscriptionActive = UserDefaults.isProVersion
    @Published var isLoading = false

    init() {
        
        Purchases.shared.getCustomerInfo { (customerInfo, error) in
            self.isSubscriptionActive = customerInfo?.entitlements.all[Constants.ENTITLEMENTS_ID]?.isActive == true
        }
    }

    func setThePurchaseStatus(isPro : Bool){
        self.isSubscriptionActive = isPro
        UserDefaults.isProVersion = isPro
    }
}
