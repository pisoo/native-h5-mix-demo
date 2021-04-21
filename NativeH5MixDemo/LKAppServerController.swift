//
//  LKAppServerController.swift
//  NativeH5MixDemo
//
//  Created by CPHKEP on 2021/4/20.
//

import UIKit
import WebKit

class LKAppServerController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    var commandID = ""
    var command: [String: String] = [:] {
        didSet(String) {

            // name， arguments 同时存在
            let name = self.command["name"]
            let args = self.command["args"]
            if (name != nil) && (args != nil) {
                didAcceptCommand(name ?? "", arguments: args ?? "")
            }
            
        }
    }
    var hasLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        let h5 = Bundle.main.url(forResource: "index", withExtension: "html")
        webView.loadFileURL(h5!, allowingReadAccessTo: Bundle.main.resourceURL!)

        command = Dictionary.init()
    }
    
    //MARK: public
    
    func didAcceptCommand(_ name: String, arguments: String) {
        print("\n❗️ H5 to App ❗️\nname = \(name)\narguments = \(arguments)")
    }
    
    func callJS(_ JSONString: String) {
        
        let JS = "AppServer.callJS(\"\(commandID)\"" + "," + JSONString + ")"
        webView.evaluateJavaScript(JS) { (response, error) in
            print("response:", response ?? "No Response", "\n", "error:", error ?? "No Error")
        }
    }
    
    
    //MARK: private
    
    private func filterCustomScheme(navigationAction: WKNavigationAction) {
        
        let url = navigationAction.request.url
        let scheme = url?.scheme?.lowercased()
        let isCustomScheme = (scheme == "demo")
        
        
        if isCustomScheme {
            
            // 自定义协议
            commandID = getCommandID(navigationAction: navigationAction)
            getCommandNameAndArguments(commandID)
        }
    }
    
    
    private func getCommandID(navigationAction: WKNavigationAction) -> String {
        
        guard let query = navigationAction.request.url?.query else { return "" }
        return query.replacingOccurrences(of: "id=", with: "")
    }
    
    
    private func getCommandNameAndArguments(_ commandID: String) {
        
        command = Dictionary.init()
        getCommandName(commandID)
        getCommandArguments(commandID)
    }

    private func getCommandName(_ commandID: String) {
        
        let JS = "AppServer.getCommandName(\"\(commandID)\")"
        webView.evaluateJavaScript(JS) { (response, error) in
            if (error == nil) {
                self.command["name"] = response as? String
            }
        }
    }
    
    private func getCommandArguments(_ commandID: String)  {

        let JS = "AppServer.getCommandArgs(\"\(commandID)\")"
        webView.evaluateJavaScript(JS) { (response, error) in
            if (error == nil) {
                self.command["args"] = response as? String
            }
        }
    }
    
    //MARK: WKNavigationDelegate
    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void)
    {
        filterCustomScheme(navigationAction: navigationAction)
        
        decisionHandler(hasLoad ? .cancel : .allow);
    }
}


