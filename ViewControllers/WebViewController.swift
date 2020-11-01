//
//  WebViewViewController.swift
//  iOS_Project_DietVision
//
//  Created by Nishit Amin on 2020-04-09.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate {

    //WKWebView to display the web page
    @IBOutlet var wbPage: WKWebView!
    //Indicator to display when page is loading
    @IBOutlet var activity : UIActivityIndicatorView!
    
    //Start animating indicator when page is loading
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activity.isHidden = false
        activity.startAnimating()
    }
    
    //Stop animating indicating when page is loaded
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.isHidden = true
        activity.stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //Assigns the url to be displayed on  page load.
        let urlAddress = URL(string: "https://developer.nutritionix.com/")
        let url = URLRequest(url: urlAddress!)
        wbPage.load(url)
        wbPage.navigationDelegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
