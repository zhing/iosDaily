//
//  WkWebViewContollerViewController.swift
//  swiftStyle
//
//  Created by Qing Zhang on 11/18/16.
//  Copyright © 2016 Qing Zhang. All rights reserved.
//

import UIKit
import WebKit
import SnapKit

class WkWebViewController: UIViewController {
    var webView :WKWebView!
    
    deinit {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        networkRequest()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        webView.addObserver(self, forKeyPath: "loading", options: NSKeyValueObservingOptions.new, context: nil)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        webView.removeObserver(self, forKeyPath: "loading")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    func setupViews() {
        // 创建一个webiview的配置项
        let configuretion = WKWebViewConfiguration()
        
        // Webview的偏好设置
        configuretion.preferences = WKPreferences()
        configuretion.preferences.minimumFontSize = 10
        configuretion.preferences.javaScriptEnabled = true
        // 默认是不能通过JS自动打开窗口的，必须通过用户交互才能打开
        configuretion.preferences.javaScriptCanOpenWindowsAutomatically = false
        
        // 通过js与webview内容交互配置
        configuretion.userContentController = WKUserContentController()
        
        // 添加一个JS到HTML中，这样就可以直接在JS中调用我们添加的JS方法
        let confirmScript = WKUserScript(source: "function showConfirm() {if(confirm('确定弹出Alert窗口吗？')){alert('在载入webview时通过Swift注入的JS方法')}}", injectionTime: WKUserScriptInjectionTime.atDocumentStart,
                                         forMainFrameOnly: true) // 只添加到mainFrame中
        let js = fetchJScript()
        let jsScript = WKUserScript(source: js, injectionTime: WKUserScriptInjectionTime.atDocumentStart, forMainFrameOnly: false)
        configuretion.userContentController.addUserScript(confirmScript)
        configuretion.userContentController.addUserScript(jsScript)
        
        // 添加一个名称，就可以在JS通过这个名称发送消息：
        configuretion.userContentController.add(self, name: "buttonClicked")
        
        webView = WKWebView(frame: self.view.bounds, configuration: configuretion)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.edges.equalTo(0);
        }
        
        setNavBar()
        addProgBar()
    }
    
    func fetchJScript() -> String {
        var script :String?
        if let filePath = Bundle.main.path(forResource: "injection", ofType: "js") {
            do {
                script = try String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
            } catch {
            
            }
        }
        return script!
    }
    
    func networkRequest() {
//        let url = URL.init(string: "http://www.baidu.com")
//        let url = URL(string: "http://csol2.tiancity.com/homepage/article/Class_1166_Time_1.html")
//        let url = URL(string: "https://ypy.douban.com/package/cate/7")
//        let url = URL(string:"http://transcoder.baidu.com/from=1099a/bd_page_type=1/ssid=0/uid=0/baiduid=42872C6D745E3CE3129A04CCB5E1F678/w=0_10_/t=iphone/l=3/tc?ref=www_iphone&pu=sz%401320_480%2Ccuid%400D13F546798D385810DDF6EBD1AFCE3F2D6413498ORRRIKOQST%2Ccua%40750_1334_iphone_8.0.1.9_0%2Ccut%40iPhone8%252C1_10.1.1%2Cosname%40baiduboxapp%2Cctv%401%2Ccfrom%401099a%2Ccsrc%40home_box_txt%2Cta%40iphone_1_10.1_6_8.0%2Cusm%403%2Cvmgdb%400020100228y&lid=4678486406490530734&order=3&fm=alop&srd=1&dict=32&otn=1&tj=we_realtime_3_0_10_l2&asres=1&w_qd=IlPT2AEptyoA_yk5wPEd6xu&sec=16763&di=9859aa32a22a0a49&bdenc=1&tch=124.316.270.592.1.142&nsrc=IlPT2AEptyoA_yixCFOxXnANedT62v3IDw3RMGBH0T_b95qshbWxBgQqE7WeASb3ZpPPujLNshoCwnyb_HhpkNYWgK&eqid=40ed5299595ca40010000001582ee452&wd=&clk_info=%7B%22srcid%22%3A%2219%22%2C%22tplname%22%3A%22we_realtime%22%2C%22t%22%3A1479468347010%2C%22xpath%22%3A%22div-div3-div-a-p%22%7D")
        let url = Bundle.main.url(forResource: "ExampleApp", withExtension: ".html")
        let request = URLRequest.init(url: url!);
        webView.load(request);
    }
    
    var btnBack :UIBarButtonItem!
    var btnForward :UIBarButtonItem!
    func setNavBar() {
        btnBack = UIBarButtonItem(title: "后退", style: UIBarButtonItemStyle.plain, target: self, action: #selector(toBack))
        btnForward = UIBarButtonItem(title: "前进", style: UIBarButtonItemStyle.plain, target: self, action:#selector(toForward))
        self.navigationItem.leftBarButtonItem = btnBack
        self.navigationItem.rightBarButtonItems = [btnForward]
    }
    
    func toBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    func toForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    var progBar : UIProgressView!
    
    func addProgBar() {
        progBar = UIProgressView()
        progBar.progress = 0.0
        progBar.tintColor = UIColor.red
        webView.addSubview(progBar)
        progBar.snp.makeConstraints { (make) in
            make.leading.equalTo(0)
            make.top.equalTo(64)
            make.trailing.equalTo(0)
            make.height.equalTo(2)
        }
        
        //wkwebview支持三个属性的监听：loading、title和estimatedProgress
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "loading" {
            if webView.isLoading {
                print("loading")
            } else {
                print("load completed")
            }
        } else if keyPath == "estimatedProgress" {
            self.progBar.alpha = 1.0
            progBar.setProgress(Float(webView.estimatedProgress), animated: true)
            if(webView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3, delay: 0.1, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    self.progBar.alpha = 0.0
                }, completion: { (Bool) in
                    self.progBar.progress = 0
                })
            }
        }
    }
    
    func invokeByJs() {
        /*
           * swift to js
           * swift调用js函数，该js函数可以在原文件中、也可以在被注入的js中、也可以在此处执行js中
           */
        print(#function)
        guard webView.isLoading else {
            webView.evaluateJavaScript("showSwiftMessage('invoke swiftHandler(invokeByJs) succeed')", completionHandler: nil)
//            let js = fetchJScript()
//            webView.evaluateJavaScript(js){ (result, error) in
//                if error != nil {
//                    print(result ?? "")
//                }
//            }
            return
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension WkWebViewController: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        
        return nil
    }
    
    // 这个方法是在HTML中调用了JS的alert()方法时，就会回调此API。
    // 注意，使用了`WKWebView`后，在JS端调用alert()就不会在HTML
    // 中显示弹出窗口。因此，我们需要在此处手动弹出ios系统的alert。
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            // We must call back js
            completionHandler()
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        let alert = UIAlertController(title: "Tip", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            // 点击完成后，可以做相应处理，最后再回调js端
            completionHandler(true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            // 点击取消后，可以做相应处理，最后再回调js端
            completionHandler(false)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        let alert = UIAlertController(title: prompt, message: defaultText, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField { (textField: UITextField) -> Void in
            textField.textColor = UIColor.red
        }
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (_) -> Void in
            // 处理好之前，将值传到js端
            completionHandler(alert.textFields![0].text!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func webViewDidClose(_ webView: WKWebView) {
        print(#function)
    }
}

extension WkWebViewController: WKNavigationDelegate {
    
    //开始加载页面内容时就会回调此代理方法，与UIWebView的didStartLoad功能相当
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    // 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
    // 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(#function)
        
        let hostname = navigationAction.request.url?.host?.lowercased()
        
        print(hostname ?? "")
        // 处理跨域问题
        if navigationAction.navigationType == .linkActivated && !hostname!.contains(".baidu.com") {
            // 手动跳转
            UIApplication.shared.open(navigationAction.request.url!, options: ["":""], completionHandler: nil)
            
            // 不允许导航
            decisionHandler(.cancel)
        } else {
            progBar.alpha = 1.0
            
            decisionHandler(.allow)
        }
    }
    
    //决定是否允许导航响应，如果不允许就不会跳转到该链接的页面
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print(#function)
        decisionHandler(.allow)
    }
    
    //Invoked when content starts arriving for the main frame
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print(#function)
    }
    
    //加载完成的回调
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        self.navigationItem.title = self.webView.title
    }
    
    //加载失败了，会回调下面的代理方法
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(#function)
    }
    
    //需要处理在重定向时，需要实现下面的代理方法就可以接收到。
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        print(#function)
    }
    
    //终止页面加载时，我们会可以处理下面的代理方法，如果不需要处理，则不用实现之
    func webViewWebContentProcessDidTerminate(_ webView: WKWebView) {
        print(#function)
    }
}

extension WkWebViewController :WKScriptMessageHandler {
    /*! @abstract Invoked when a script message is received from a webpage.
     @param userContentController The user content controller invoking the
     delegate method.
     @param message The script message received.
     */
    @available(iOS 8.0, *)
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        
        /*
           *  js to swift
           *  just a magic message(can be object)
           */
        if message.name == "buttonClicked" {
            if let messageBody:NSDictionary = message.body as? NSDictionary {
                if messageBody["type"] as! String == "plainText" {
                    let idOfTappedButton:String = messageBody["ButtonId"] as! String
                    print(idOfTappedButton)
                } else if messageBody["type"] as! String == "invoke" {
                    let className = messageBody["className"] as! String
                    let functionName = messageBody["functionName"] as! String
                    if let cls = NSClassFromString((Bundle.main.object(forInfoDictionaryKey: "CFBundleName")! as AnyObject).description + "." + className) as? NSObject.Type{
                        var obj :NSObject
                        if cls == self.classForCoder {
                            obj = self
                        } else {
                            obj = cls.init()
                        }
                        let functionSelector = Selector(functionName)
                        if obj.responds(to: functionSelector) {
                            obj.perform(functionSelector)
                        } else {
                            print("方法未找到！")
                        }
                    } else {
                        print("类未找到！")
                    }
                }
            }
        }
    }
}







