//
//  DetailViewController.swift
//  grant-pdf-viewer
//
//  Created by Phil Hauser on 03/08/2015.
//  Copyright (c) 2015 Phil Hauser. All rights reserved.
//

import UIKit
import Foundation

class DetailViewController: UIViewController {
    
    var docController:UIDocumentInteractionController!

    let pdfStoreInstance = PdfStore.sharedInstance
    
    var detailItem: PdfObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    

    @IBOutlet var pdfWebView: UIWebView!
    
    
    func exportFunction() {
        docController.presentOptionsMenu(from: CGRect.zero, in: self.view, animated: true)
    }
    
    
    func configureView() {
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(DetailViewController.exportFunction))
        
        let detail: PdfObject = self.detailItem!
        
        if let pdf = Bundle.main.url(forResource: detail.name, withExtension: "pdf", subdirectory: "pdfjs/pdfs", localization: nil){
            if let pdfjsViewer = Bundle.main.url(forResource: "viewer", withExtension: "html", subdirectory: "pdfjs", localization: nil)  {
                if let pdfQueryString =  pdf.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed){
                    let url =  pdfjsViewer.absoluteString + "?file=" + pdfQueryString
                    let formattedURL = URL(string: url)
                    print(formattedURL)
                    let req = URLRequest(url: formattedURL!)
                    self.pdfWebView?.loadRequest(req)
                }
            }
            docController = UIDocumentInteractionController(url: pdf)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

