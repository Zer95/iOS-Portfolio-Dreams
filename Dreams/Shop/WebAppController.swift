//
//  WebAppController.swift
//  Dreams
//
//  Created by SG on 2021/08/27.
//

import UIKit
import WebKit

class WebAppController: UIViewController {
    var webView: WKWebView!
    final let bridgeName = "dreams"
    final let ios_application_id = "6128b7b67b5ba4002352a8ac" // iOS

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }

    func setUI() {
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always  // 현대카드 등 쿠키설정 이슈 해결을 위해 필요
        let configuration = WKWebViewConfiguration() //wkwebview <-> javasscript function(bootpay callback)
        configuration.userContentController.add(self, name: bridgeName)
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)


        let url = URL(string: "https://{개발하신 웹 페이지 주소}")
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}

extension WebAppController:  WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler  {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        registerAppId() //필요시 App ID를 아이폰 값으로 바꿉니다
        setDevice() //기기환경을 IOS로 등록합니다. 이 작업을 수행해야 통계에 iOS로 잡히며, iOS Application ID 값을 호출하여 결제를 사용할 수 있습니다.
        startTrace() // 통계 - 페이지 방문, 원래는 웹 페이지에서 호출하시는게 맞습니다.
        registerAppIdDemo() //필요시 App ID를 아이폰 값으로 바꿉니다
    }

    func registerAppId() {
        doJavascript("BootPay.setApplicationId([iOS SDK용 Application ID]);")
    }

    func registerAppIdDemo() {
        doJavascript("window.setApplicationId([iOS SDK용 Application ID]);")
    }

    internal func setDevice() {
        doJavascript("window.BootPay.setDevice('IOS');")
    }

    internal func startTrace() {
        doJavascript("BootPay.startTrace();")
    }
}

extension WebAppController:  WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler  {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if(message.name == self.bridgeName) {
            guard let body = message.body as? [String: Any] else {
                if message.body as? String == "close" {
                    onClose()
                }
                return
            }
            guard let action = body["action"] as? String else {
                return
            }

            // 해당 함수 호출
            if action == "BootpayCancel" {
                onCancel(data: body)
            } else if action == "BootpayError" {
                onError(data: body)
            } else if action == "BootpayBankReady" {
                onReady(data: body)
            } else if action == "BootpayConfirm" {
                onConfirm(data: body)
            } else if action == "BootpayDone" {
                onDone(data: body)
            }
        }
    }
}


//MARK: Bootpay Callback Protocol
extension WebAppController {
    // 에러가 났을때 호출되는 부분
    func onError(data: [String: Any]) {
        print(data)
    }

    // 가상계좌 입금 계좌번호가 발급되면 호출되는 함수입니다.
    func onReady(data: [String: Any]) {
        print(data)
    }

    // 결제가 진행되기 바로 직전 호출되는 함수로, 주로 재고처리 등의 로직이 수행
    func onConfirm(data: [String: Any]) {
        print(data)

        let iWantPay = true
        if iWantPay == true {  // 재고가 있을 경우.
            let json = dicToJsonString(data).replace(target: "\"", withString: "'")
            doJavascript("BootPay.transactionConfirm( \(json) );"); // 결제 승인
        } else { // 재고가 없어 중간에 결제창을 닫고 싶을 경우
            doJavascript("BootPay.removePaymentWindow();");
        }
    }

    // 결제 취소시 호출
    func onCancel(data: [String: Any]) {
        print(data)
    }

    // 결제완료시 호출
    // 아이템 지급 등 데이터 동기화 로직을 수행합니다
    func onDone(data: [String: Any]) {
        print(data)
    }

    //결제창이 닫힐때 실행되는 부분
    func onClose() {
        print("close")
    }
}
