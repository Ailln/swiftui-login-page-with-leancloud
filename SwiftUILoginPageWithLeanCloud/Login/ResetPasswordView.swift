//
//  ResetPasswordView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI
import LeanCloud

struct ResetPaswordView: View {
    @Binding var isActiveReset: Bool
    
    @State var phone = ""
    @State var code = ""
    @State private var timeRemaining = 60
    @State private var isTimerActive = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
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
                    Image("Signup").resizable().frame(width: 400, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                }
                Spacer()
                VStack{
                    HStack{
                        Image(systemName: "person").foregroundColor(.gray).padding()
                        TextField("请输入手机号", text: $phone).keyboardType(.numberPad)
                        if phone.count > 0 {
                            EmptyView().modifier(Validation(value: phone) { p in
                                return p.count == 11
                            })
                        }
                    }.overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                    .foregroundColor(.gray).padding(.horizontal)
                    
                    HStack{
                        Image(systemName: "number").foregroundColor(.gray).padding()
                        TextField("请输入验证码", text: $code).keyboardType(.numberPad)
                        if code.count > 0 {
                            EmptyView().modifier(Validation(value: code) { p in
                                return p.count == 6
                            })
                        }
                        Button(action: {
                            isShowLoading = true
                            if phone.count == 11 {
                                isTimerActive = true

                                _ = LCUser.requestPasswordReset(mobilePhoneNumber: "+86\(phone)") { (result) in
                                    isShowLoading = false
                                    switch result {
                                    case .success:
                                        alertTitle = "通知"
                                        alertMessage = "验证码发送成功，请查收～"
                                        isShowAlert = true
                                        break
                                    case .failure(error: let error):
                                        alertTitle = "错误"
                                        alertMessage = error.reason ?? "未知错误"
                                        isShowAlert = true
                                        print(error)
                                    }
                                }
                            } else {
                                isShowLoading = false
                                isShowAlert = true
                                alertTitle = "错误"
                                alertMessage = "「手机号」不符合规范！"
                            }
                        }, label: {
                            Text(isTimerActive ? "\(timeRemaining)s 后重试" : "获取验证码").padding().foregroundColor(isTimerActive ? .gray : /*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                        }).disabled(isTimerActive)
                    }.foregroundColor(.gray)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1)).padding(.horizontal)
                    .onReceive(timer) { time in
                        guard isTimerActive else { return }
                        if timeRemaining > 1 {
                            timeRemaining -= 1
                        } else {
                            isTimerActive = false
                        }
                    }
                    
                    HStack{
                        Image(systemName: "lock").foregroundColor(.gray).padding()
                        SecureField("请输入新密码", text: $password).keyboardType(.namePhonePad)
                        if password.count > 0 {
                            EmptyView().modifier(Validation(value: password) { p in
                                return p.count > 5 && p.count < 16
                            })
                        }
                    }.foregroundColor(.gray)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1)).padding(.horizontal)
                    
                    Button(action: {
                        isShowLoading = true
                        if (phone.count == 11 && code.count == 6 && password.count > 5 && password.count < 16){
                            _ = LCUser.resetPassword(mobilePhoneNumber: "+86\(phone)", verificationCode: code, newPassword: password) { result in
                                isShowLoading = false
                                switch result {
                                case .success:
                                    alertTitle = "通知"
                                    alertMessage = "密码重置成功～"
                                    isShowAlert = true
                                    isActiveReset = false
                                    break
                                case .failure(error: let error):
                                    alertTitle = "错误"
                                    alertMessage = error.reason ?? "未知错误"
                                    isShowAlert = true
                                }
                            }
                        } else {
                            isShowLoading = false
                            isShowAlert = true
                            alertTitle = "错误"
                            alertMessage = "「手机号」或「验证码」或「密码」不符合规范！"
                        }
                    }, label: {
                        Text("重置").frame(width: 360, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding().background(Color.blue).foregroundColor(.white)
                            .cornerRadius(15)
                    }).padding()
                    Spacer()
                }
                
            }.navigationBarTitle("重置")
            .alert(isPresented: $isShowAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("确认")))
            }.disabled(isShowLoading)
            
            if isShowLoading {
                LoadingView()
            }
        }
    }
}

struct ResetPaswordView_Previews: PreviewProvider {
    @State static var isActiveReset = false
    static var previews: some View {
        ResetPaswordView(isActiveReset: $isActiveReset)
    }
}

