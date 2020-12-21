//
//  PersonTabView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//


import SwiftUI
import LeanCloud


struct PersonTabView: View {
    @Binding var loginType: Int
    
    let user = LCApplication.default.currentUser
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    HStack {
                        Image(systemName: "person.crop.circle.fill").imageScale(.large)
                        VStack(alignment: .leading) {
                            Text(user?.username?.value ?? "游客").font(.title)
                            Text(user?.mobilePhoneNumber?.value ?? "无").font(.subheadline)
                        }.padding()
                    }
 
                    NavigationLink(destination: CheckPhoneView() ){
                        HStack {
                            Image(systemName: "checkmark.shield").imageScale(.large)
                            Text("验证手机号").frame(alignment: .leading).padding()
                        }
                    }
                    if user?.mobilePhoneVerified?.value != true {
                        Text("手机号未验证，若忘记密码，则账号无法找回！").font(.subheadline).foregroundColor(.red)
                    }
                }
                
                Section{
                    NavigationLink(destination: Text("系统设置") ){
                        HStack {
                            Image(systemName: "gearshape").imageScale(.large)
                            Text("系统设置").padding()
                        }
                    }
                    NavigationLink(destination: Text("统计信息")){
                        HStack {
                            Image(systemName: "doc.text.below.ecg").imageScale(.large)
                            Text("统计信息").padding()
                        }
                    }
                }
            }.navigationBarTitle("个人中心")
            .navigationBarItems(trailing: Button(action: {
                if user != nil {
                    LCUser.logOut()
                    loginType = 0
                } else {
                    loginType = 0
                }
            }, label: {
                Text(user != nil ? "退出账号" : "登录 / 注册")
            }))
        }
    }
}

struct PersonTabView_Previews: PreviewProvider {
    @State static var loginType = 1
    static var previews: some View {
        PersonTabView(loginType: $loginType)
    }
}
