//
//  ContentView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI
import LeanCloud

struct ContentView: View {
    @State private var loginType = 0 // 0: 未登录; 1: 游客; 2: 正式用户
    @State private var tabSelection = 0
    
    let user = LCApplication.default.currentUser

    var body: some View {
        VStack{
            if loginType != 0 {
                TabView(selection: $tabSelection){
                    HomeTabView(loginType: $loginType).tabItem{
                        Image(systemName: "scribble.variable")
                        Text("主页")
                    }.tag(0)
                    
                    PersonTabView(loginType: $loginType).tabItem {
                        Image(systemName: "person")
                        Text("个人")
                    }.tag(1)
                }
            } else {
                WelcomeView(loginType: $loginType)
            }
        }.onAppear{
            loginType = (user != nil) ? 2 : 0
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
