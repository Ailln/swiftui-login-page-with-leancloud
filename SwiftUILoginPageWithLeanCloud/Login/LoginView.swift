//
//  LoginView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI
import LeanCloud

struct LoginView: View {
    @Binding var loginType: Int
    @State var username = ""
    @State var password = ""

    @State var isShowAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var isActiveReset = false
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
                    .padding(.horizontal).foregroundColor(.gray)
                    
                    HStack{
                        Image(systemName: "lock").foregroundColor(.gray).padding()
                        SecureField("请输入密码，长度为 6-12", text: $password).keyboardType(.namePhonePad)
                        if password.count > 0 {
                            EmptyView().modifier(Validation(value: password) { item in
                                return item.count > 5 && item.count < 16
                            })
                        }
                    }.overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                    .padding(.horizontal).foregroundColor(.gray)
                    
                    HStack {
                        Spacer()
                        NavigationLink(
                            destination: ResetPaswordView(isActiveReset: $isActiveReset),
                            isActive: $isActiveReset,
                            label: {
                                Text("忘记密码").foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                            }).padding()
                    }
                    Button(action: {
                        isShowLoading = true
                        if (username.count > 2 && username.count < 11) && (password.count > 5 && password.count < 16) {
                            _ = LCUser.logIn(username: username, password: password) { result in
                                isShowLoading = false
                                switch result {
                                case .success(object: let user):
                                    isShowAlert = true
                                    alertTitle = "通知"
                                    alertMessage = "登录成功！"
                                    loginType = 2
                                    print(user)
                                case .failure(error: let error):
                                    isShowAlert = true
                                    alertTitle = "错误"
                                    alertMessage = error.reason ?? "未知错误"
                                    print(error)
                                }
                            }
                        } else {
                            isShowLoading = false
                            isShowAlert = true
                            alertTitle = "错误"
                            alertMessage = "「用户名」或「密码」不符合规范！"
                        }
                    }, label: {
                        Text("登录").frame(width: 360, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding().background(Color.blue).foregroundColor(.white)
                            .cornerRadius(15)
                    }).padding()
                    Spacer()
                }
            }.navigationBarTitle("登录")
            .alert(isPresented: $isShowAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("确认")))
            }.disabled(isShowLoading)
            if isShowLoading {
                LoadingView()
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    @State static var loginType = 1
    static var previews: some View {
        LoginView(loginType: $loginType)
    }
}
