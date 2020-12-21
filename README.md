# SwiftUI Login Page with LeanCloud

一份使用 **LeanCloud 服务**实现的、具有「**登录注册功能**」的 **SwiftUI 代码**。

## 1 功能

- 用户注册
- 用户登录
- 密码找回
- 手机号验证
- 手机号登录（Todo）

> 注意：仅支持 iOS 14.0 以上

## 2 演示

![](./.github/DEMO.gif)

## 3 使用

1. 下载项目
2. 添加依赖
  在 `File > Swift Packages > Add Package Dependency...` 中加入 LeanCloud 的 URL：`https://github.com/leancloud/swift-sdk`，一路确认稍等片刻即可。
3. 修改配置
    找到 `SwiftUILoginPageWithLeanCloud/SwiftUILoginPageWithLeanCloud/SwiftUILoginPageWithLeanCloudApp.swift` 文件的 init() 代码，修改 LeanCloud 的应用配置。
    ```swift
    // 在 leancloud 应用 Keys 中
    let appid = ""
    let appkey = ""
    let url = ""
    ```
4. 配置 Xcode 账号
    添加 `Signing` 中找到 Team，添加自己的开发者账号。
5. RUN 就 vans 了～

## 4 参考

- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui/)
- [LeanCloud](https://leancloud.cn/)

## 5 许可

[MIT License](./LICENSE)
