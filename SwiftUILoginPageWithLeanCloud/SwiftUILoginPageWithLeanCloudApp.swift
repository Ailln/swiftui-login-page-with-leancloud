//
//  SwiftUILoginPageWithLeanCloudApp.swift
//  SwiftUILoginPageWithLeanCloud
//
//  Created by Ailln on 2020/12/22.
//

import SwiftUI
import LeanCloud

@main
struct SwiftUILoginPageWithLeanCloudApp: App {
    init() {
        // leancloud 应用 Keys 中
        let appid = ""
        let appkey = ""
        let url = ""
        
        do { try LCApplication.default.set(id: appid, key: appkey, serverURL: url) }
        catch { print(error) }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct Validation<Value>: ViewModifier {
    var value: Value
    var validator: (Value) -> Bool
    
    func body(content: Content) -> some View {
        Group {
            if validator(value) {
                content
                Image(systemName: "checkmark.circle.fill").foregroundColor(.green).padding()
            } else {
                content
                Image(systemName: "xmark.octagon.fill").foregroundColor(.red).padding()
            }
        }
    }
}
