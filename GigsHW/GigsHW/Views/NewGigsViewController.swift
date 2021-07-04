//
//  NewGigsViewController.swift
//  GigsHW
//
//  Created by Michael Flowers on 5/9/19.
//  Copyright © 2019 Michael Flowers. All rights reserved.
//

import UIKit

class NewGigsViewController: UIViewController {
    
    var gc: GigController?{
        didSet{
            print("gc was passed into the gigVC")
        }
    }
    var gig: Gig? {
        didSet {
            print("gig was passed into gigVC")
            updateViews()
        }
    }
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var textView: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
    }
    
    @IBAction func saveGig(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty, let body = textView.text, !body.isEmpty, let gc = gc else { return }
        
        gc.createGig(with: title, dueDate: datePicker.date, descripton: body) { (error) in
            if let error = error {
                print("Error in  call of our crateGig function: \(error.localizedDescription)")
                return
            }
            
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateViews(){
        guard let passedInGig = gig, isViewLoaded else {
            title = "New Gig"
            return}
        title = passedInGig.title
        titleTextField.text = passedInGig.title
        textView.text = passedInGig.description
    }
}
