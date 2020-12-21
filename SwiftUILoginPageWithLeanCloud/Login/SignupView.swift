//
//  SignupView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI
import LeanCloud

struct SignupView: View {
    @Binding var isActiveSignup: Bool
    @Binding var isActiveLogin: Bool
    
    @State var username = ""
    @State var password = ""
    
    @State var isShowAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var isShowLoading = false
    
    var body: some View {
        ZStack{
            VStack{
                Spacer()
                VStack{
                    Image("Login").resizable().frame(width: 400, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                VStack{
                    HStack{
                        Image(systemName: "person").foregroundColor(.gray).padding()
                        TextField("请输入用户名，长度为 3-10", text: $username).keyboardType(.namePhonePad)
                        if username.count > 0 {
                            EmptyView().modifier(Validation(value: username) { item in
                                return item.count > 2 && item.count < 11
                            })
                        }
                    }.overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                    .foregroundColor(.gray).padding(.horizontal)
                    
                    HStack{
                        Image(systemName: "lock").foregroundColor(.gray).padding()
                        SecureField("请输入密码，长度为 6-12", text: $password).keyboardType(.namePhonePad)
                        if password.count > 0 {
                            EmptyView().modifier(Validation(value: password) { item in
                                return item.count > 5 && item.count < 13
                            })
                        }
                    }.overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                    .foregroundColor(.gray).padding(.horizontal)
                    
                    Button(action: {
                        isShowLoading = true
                        if (username.count > 2 && username.count < 11) &&  (password.count > 5 && password.count < 13) {
                            let user = LCUser()
                            user.username = LCString(username)
                            user.password = LCString(password)
                            _ = user.signUp { (result) in
                                isShowLoading = false
                                switch result {
                                case .success:
                                    // 返回上一页，进入登录页
                                    isActiveSignup = false
                                    isActiveLogin = true
                                    break
                                case .failure(error: let error):
                                    alertTitle = "错误"
                                    alertMessage = error.reason ?? "未知错误"
                                    isShowAlert = true
                                }
                            }
                        } else {
                            isShowLoading = false
                            alertTitle = "错误"
                            alertMessage = "「用户名」或「密码」不符合规范！"
                            isShowAlert = true
                        }
                    }, label: {
                        Text("注册").frame(width: 360, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding().background(Color.blue).foregroundColor(.white)
                            .cornerRadius(15)
                    }).padding()
                    Spacer()
                }
            }.navigationBarTitle("注册")
            .alert(isPresented: $isShowAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("确认")))
            }.disabled(isShowLoading)
            
            if isShowLoading {
                LoadingView()
            }
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    @State static var isActiveSignup = true
    @State static var isActiveLogin = false

    static var previews: some View {
        SignupView(isActiveSignup: $isActiveSignup, isActiveLogin: $isActiveLogin)
    }
}

