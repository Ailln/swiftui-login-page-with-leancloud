//
//  CheckPhoneView.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI
import LeanCloud

struct CheckPhoneView: View {
    @State var phone = ""
    @State var code = ""
    @State private var timeRemaining = 60
    @State private var isTimerActive = false
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    @State var isShowAlert = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    @State var isShowLoading = false
    
    @State var isPhoneVerified = false
    
    var body: some View {
        ZStack{
            if isPhoneVerified {
                VStack{
                    Image(systemName: "checkmark.circle.fill").foregroundColor(.green).imageScale(.large).padding()
                    Text("手机号已经验证").font(.title).padding()
                }
            } else {
                VStack{
                    HStack{
                        Image(systemName: "person").foregroundColor(.gray).padding()
                        TextField("请输入手机号", text: $phone).keyboardType(.numberPad)
                    }.foregroundColor(.gray)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1)).padding()
                    
                    HStack{
                        Image(systemName: "number").foregroundColor(.gray).padding()
                        TextField("请输入验证码", text: $code).keyboardType(.numberPad)
                        Button(action: {
                            isShowLoading = true
                            isTimerActive = true
                            
                            let user = LCApplication.default.currentUser
                            user?.mobilePhoneNumber = LCString("+86\(phone)")
                            _ = user?.save() {result in
                                isShowLoading = false
                                switch result {
                                case .success:
                                    _ =  LCUser.requestVerificationCode(mobilePhoneNumber: "+86\(phone)") { result in
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
                                    break
                                case .failure(error: let error):
                                    alertTitle = "错误"
                                    alertMessage = error.reason ?? "未知错误"
                                    isShowAlert = true
                                    print(error)
                                }
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
                    
                    Button(action: {
                        isShowLoading = true
                        if phone.count == 11 {
                            _ = LCUser.verifyMobilePhoneNumber("+86\(phone)", verificationCode: code) { result in
                                isShowLoading = false
                                switch result {
                                case .success:
                                    alertTitle = "通知"
                                    alertMessage = "「手机号」验证成功！"
                                    isShowAlert = true
                                    isPhoneVerified = true
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
                            alertTitle = "错误"
                            alertMessage = "「手机号」不符合规范！"
                            isShowAlert = true
                        }
                    }, label: {
                        Text("验证").frame(width: 360, height: 22, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding().background(Color.blue).foregroundColor(.white)
                            .cornerRadius(15)
                    }).padding()
                    Spacer()
                }.navigationBarTitle("验证手机").alert(isPresented: $isShowAlert) {
                    Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("确认")))
                }.disabled(isShowLoading)
            }
            
            if isShowLoading {
                LoadingView()
            }
        }.onAppear{
            let user = LCApplication.default.currentUser
            isPhoneVerified = user?.mobilePhoneVerified?.value ?? false
        }
    }
}

struct CheckPhoneView_Previews: PreviewProvider {
    static var previews: some View {
        CheckPhoneView()
    }
}
