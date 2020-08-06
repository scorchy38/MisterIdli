//
//  MenuView.swift
//  MrIdli
//
//  Created by govind on 06/08/20.
//  Copyright © 2020 govind. All rights reserved.
//

import UIKit
import WebKit
import Firebase

class MenuView : UIViewController, WKNavigationDelegate{
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var progressView : UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.startAnimating()
        let db = Firestore.firestore()
        db.collection("Menu").document("menu").getDocument{(document, error) in
            if let document = document, document.exists {
                let documenturl = document.get("url") as! String
                self.webView.navigationDelegate = self
                       let url = URL(string: documenturl)!
                self.webView.load(URLRequest(url: url))
                self.webView.allowsBackForwardNavigationGestures = true
            }
        }
        
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.progressView.stopAnimating()
        self.progressView.isHidden = true
    }
 
    
}
