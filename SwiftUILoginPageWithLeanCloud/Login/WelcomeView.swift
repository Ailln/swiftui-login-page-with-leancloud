//
//  WelcomeView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI

struct WelcomeView: View {
    @Binding var loginType: Int
    
    @State var isActiveLogin = false
    @State var isActiveSignup = false
    
    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Spacer()
                    Text("V1.0.0").font(.footnote).fontWeight(.light).foregroundColor(Color.gray).padding().padding(.trailing)
                }
                Spacer()
                VStack{
                    Text("Login Demo").font(.largeTitle).fontWeight(.regular).padding()
                    Text("SwiftUI Login Page with LeanCloud by Ailln.").font(.subheadline).fontWeight(.light)
                    Image("Welcome").resizable().frame(width: 400, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                VStack{
                    NavigationLink(destination: LoginView(loginType: $loginType), isActive: $isActiveLogin){
                        Button(action: {
                            isActiveLogin = true
                        }){
                            Text("我要登录").frame(width: 340, height: 22, alignment: .center)
                                .padding().background(Color.blue).foregroundColor(.white).cornerRadius(6)
                        }
                    }
                    
                    HStack{
                        NavigationLink(destination: SignupView(isActiveSignup: $isActiveSignup, isActiveLogin: $isActiveLogin), isActive: $isActiveSignup){
                            Button(action: {
                                isActiveSignup = true
                            }){
                                Text("马上注册").frame(width: 180, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding()
                                    .foregroundColor(.blue).overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.blue, lineWidth: 1))
                            }
                        }.padding(.vertical)
                        
                        Button(action: {
                            loginType = 1
                        }){
                            Text("随便看看").frame(width: 100, height: 20, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).padding()
                                .foregroundColor(.gray).overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.gray, lineWidth: 1)).padding(.leading)
                        }.padding(.vertical)
                    }
                }
                Spacer()
            }.navigationBarTitle("欢迎页").navigationBarHidden(true)
        }
    }
}

struct WelcomeView_Previews: PreviewProvider {
    @State static var loginType = 1
    static var previews: some View {
        Group {
            WelcomeView(loginType: $loginType)
        }
    }
}

