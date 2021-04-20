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
    var hasLoad = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        let h5 = Bundle.main.url(forResource: "h5/index", withExtension: "html")
        webView.loadFileURL(h5!, allowingReadAccessTo: Bundle.main.resourceURL!)
    }
    
    //MARK: public
    
    func didAcceptCommand(_ name: String, arguments: String) {
        print("\n❗️ H5 to App ❗️\nname = \(name)\narguments = \(arguments)")
    }
    
    //MARK: private
    
    private func filterCustomScheme(navigationAction: WKNavigationAction) {
        
        let url = navigationAction.request.url
        let scheme = url?.scheme?.lowercased()
        let isCustomScheme = (scheme == "demo")
        
        
        if isCustomScheme {
            
            // 自定义协议
            commandID = getCommandID(navigationAction: navigationAction)
            let name = getCommandName(commandID)
            let arguments = getCommandArguments(commandID)
            
            didAcceptCommand(name, arguments: arguments);
        }
    }
    
    private func getCommandID(navigationAction: WKNavigationAction) -> String {
        
        guard let query = navigationAction.request.url?.query else { return "" }
        return query.replacingOccurrences(of: "demo:id=", with: "")
    }
    
    
    private func getCommandName(_ commandID: String) -> String {
        
        var name = ""
        let JS = "AppServer.getCommandName(\"\(commandID)\")"
        webView.evaluateJavaScript(JS) { (response, error) in
            name = (error == nil) ? (response as! String): ""
        }
                
        return name
    }
    
    private func getCommandArguments(_ commandID: String) -> String {
        
        var arguments = ""
        let JS = "AppServer.getCommandName(\"\(commandID)\")"
        webView.evaluateJavaScript(JS) { (response, error) in
            arguments = (error == nil) ? (response as! String): ""
        }
        
        return arguments
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


