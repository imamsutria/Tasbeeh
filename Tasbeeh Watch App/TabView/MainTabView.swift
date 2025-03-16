//
//  MainTabView.swift
//  Tasbeeh
//
//  Created by Imam Sutria on 15/03/25.
//

import SwiftUI

struct MainTabView: View {
    
    //    @State var currentView = 1
    var body: some View {
        TabView(){
            TasbeehView().tag(1)
            PrayeerTimes().tag(2)
        }
        .tabViewStyle(.verticalPage)
    }
}

#Preview {
    MainTabView()
        .background(Color(red: 0.012, green: 0.299, blue: 0.326))
}
