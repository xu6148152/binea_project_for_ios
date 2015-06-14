//
//  DiagnosedHistoryViewController.swift
//  Psychologist
//
//  Created by Binea Xu on 6/14/15.
//  Copyright (c) 2015 Binea Xu. All rights reserved.
//

import UIKit

class DiagnosedHistoryViewController: UIViewController {
    
    var text : String = ""{
        didSet{
            textView?.text = text
        }
    }
    
    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.text = text
        }
    }
    
    override var preferredContentSize: CGSize{
        set{
            super.preferredContentSize = newValue

        }
        
        get{
            if textView != nil && presentingViewController != nil{
                return textView.sizeThatFits(presentingViewController!.view.bounds.size)
            }else{
                return super.preferredContentSize
            }
        }
    }

}
