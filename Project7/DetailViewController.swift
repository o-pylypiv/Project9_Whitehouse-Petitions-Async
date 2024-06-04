//
//  DetailViewController.swift
//  Project7
//
//  Created by Olha Pylypiv on 25.01.2024.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }

        let html = """
        <html>
            <head>
                <meta name="viewport" content="width=device-width, initial-scale=1">
                <style> body { font-size: 150%; } </style>
            </head>
            <body>
                <b>
                    \(detailItem.title)
                </b>
                <p style = "font-size: 90%;" >
                    \(detailItem.body)
                </p>
                <p style = "font-size: 90%;" >
                    Signature count is: <u>\(detailItem.signatureCount)</u>
                </p>
                
            </body>
        </html>
        """

        webView.loadHTMLString(html, baseURL: nil)
        // Do any additional setup after loading the view.
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
