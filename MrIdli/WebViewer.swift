//
//  WebViewer.swift
//  MrIdli
//
//  Created by govind on 05/08/20.
//  Copyright © 2020 govind. All rights reserved.
//

import UIKit
import WebKit

class WebViewer : UIViewController, WKNavigationDelegate{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    override func viewDidLoad() {
        progressView.startAnimating()
        super.viewDidLoad()
        webView.navigationDelegate = self
        let url = URL(string: "https://order.chatfood.io/mister-idli-restaurant/delivery")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        //swipe back
        let swiperight = UISwipeGestureRecognizer(target: self, action:#selector(WebViewer.swipeRight))
        swiperight.direction = .right
        view.addGestureRecognizer(swiperight)
    }
        
    @objc func swipeRight(){
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Main")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.stopAnimating()
        self.progressView.isHidden = true
    }
    
}
