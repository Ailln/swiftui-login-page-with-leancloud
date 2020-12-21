//
//  HomeTabView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI


struct HomeTabView: View {
    @Binding var loginType: Int

    @State var text = Date().description

    var body: some View {
        NavigationView{
            VStack{
                Text("当前时间：\(text)")
            }.navigationBarTitle("APP 主页")
            .navigationBarItems(trailing: Button(action: {
                // 游客
                if loginType == 1 {
                    loginType = 0
                } else {
                    text = Date().description
                }
            }, label: {
                Text(loginType == 1 ? "登录 / 注册" : "更新时间")
            }))
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    @State  static var loginType = 1
    static var previews: some View {
        HomeTabView(loginType: $loginType)
    }
}
