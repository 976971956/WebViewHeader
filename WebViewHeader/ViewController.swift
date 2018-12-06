//
//  ViewController.swift
//  WebViewHeader
//
//  Created by 李江湖 on 2018/12/6.
//  Copyright © 2018年 李江湖. All rights reserved.
//
///方案1
import UIKit

class ViewController: UIViewController,UIWebViewDelegate {
    let height :CGFloat = 200.0
    
    lazy var webView = {()->UIWebView in
        let webView  = UIWebView(frame: CGRect(x: 0, y: 0, width:UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height))
        webView.backgroundColor = UIColor.white
        webView.isOpaque = false
        webView.delegate = self
        return webView
    }()
//    webview加载完成
    func webViewDidFinishLoad(_ webView: UIWebView) {
//        获取webView高度
//        方法1 // 记录高度,有时候计算的高度不准确
        let webViewHeight1 = webView.stringByEvaluatingJavaScript(from: "document.body.scrollHeight") ?? ""
        let webViewHeight2 = webView.stringByEvaluatingJavaScript(from: "document.body.offsetHeight") ?? ""
        let webViewHeight3 = webView.stringByEvaluatingJavaScript(from: "document.body.clientHeight") ?? ""
        print("方法1:\(webViewHeight1):\(webViewHeight2):\(webViewHeight3)")
//        方法2
        let webViewHeight4 = webView.scrollView.contentSize.height
        print("方法2:\(webViewHeight4)")
//        方法3
        let size = webView.sizeThatFits(CGSize.zero)
        
        print("方法3:\(size.height)")
//        方法4
        if webView.subviews.count > 0 {
            let scrollerView = webView.subviews[0];
            if scrollerView.subviews.count > 0 {
                let webDocView = scrollerView.subviews.last;
                let webViewHeight = webDocView!.frame.size.height;
                print("方法4\(webViewHeight)")
                if webDocView?.classForCoder == NSClassFromString("UIWebDocumentView") {
                    let webViewHeight = webDocView!.frame.size.height;
                    print("方法4\(webViewHeight)")

                    // 更新表上控件的frame
                    // _webView,时间控件,查看数,评论数...的frame,整个表头的frame,再来一句
                }
            }
        }

    }
//    方法1
    private func addHeaderView1() {
//        内容偏移height
        webView.scrollView.contentInset = UIEdgeInsetsMake(height, 0, 0, 0)
//        内容的初始位置-height
        webView.scrollView.contentOffset = CGPoint(x: 0, y: -height)
//        内容高度 = 原始高度 - height
        webView.scrollView.contentSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height-height)
//        添加头部
        let headerView = UIView(frame: CGRect(x: 0, y:-height, width: UIScreen.main.bounds.size.width, height: height))
        headerView.backgroundColor = UIColor.yellow
        self.webView.scrollView.addSubview(headerView)

    }
//    方法2
    private func addHeaderView2() {
        let headerView = UIView(frame: CGRect(x: 0, y:0, width: UIScreen.main.bounds.size.width, height: height))
        headerView.backgroundColor = UIColor.yellow
        let browserCanvas = webView.bounds
        
        for subView in webView.scrollView.subviews {
            var subViewRect = subView.frame
            if(subViewRect.origin.x == browserCanvas.origin.x &&
                subViewRect.origin.y == browserCanvas.origin.y &&
                subViewRect.size.width == browserCanvas.size.width &&
                subViewRect.size.height == browserCanvas.size.height)
            {
                let height              = headerView.frame.size.height
            //        内容偏移height
                subViewRect.origin.y    = height
            //        内容高度 = 原始高度 - height
                subViewRect.size.height = subViewRect.size.height - height
//                重新设置高度
                subView.frame           = subViewRect
            }
        }
        webView.scrollView.addSubview(headerView)
        webView.scrollView.bringSubview(toFront: headerView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 11.0, *) {
            self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentBehavior.never
        } else {
            self.webView.scrollView.autoresizesSubviews = false;
        }
        self.view.addSubview(self.webView)
        self.addHeaderView1()
        self.webView.loadRequest(URLRequest(url: URL(string: "http://www.baidu.com")!))
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

