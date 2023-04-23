//
//  AdMobView.swift
//  jamaica
//
//  Created by Takaya Ito on 2023/04/24.
//

import Foundation
import SwiftUI

import GoogleMobileAds

struct AdMobView: UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<AdMobView>) -> GADBannerView{
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        
        banner.adUnitID = "ca-app-pub-3306504766792743/7546675652"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context:  UIViewRepresentableContext<AdMobView>) {
    }
}
