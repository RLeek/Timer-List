//
//  NewCellController.swift
//  TimerList
//
//  Created by Ricky Liu on 8/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit

class NewCellController: UIViewController,UITextFieldDelegate {

    //MARK: Data
    var textname: String?;
    var save: Bool = false;
    
    //MARK: Storyboard Elements
    @IBOutlet weak var TextField: UITextField!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SaveButton.isEnabled = false;
        let navbar = self.navigationController!.navigationBar
        navbar.shadowImage = #imageLiteral(resourceName: "greycolor");
        TextField.returnKeyType = UIReturnKeyType.done
        self.TextField.delegate = self 

    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    // MARK: Actions
    @IBAction func NameValidation(_ sender: Any) {
        if TextField.text != "" {
            SaveButton.isEnabled = true;
            textname = TextField.text;
        } else {
            SaveButton.isEnabled = false;
            textname = nil;
        }
    }

    @IBAction func Saveexit(_ sender: Any) {
        save = true;
        self.performSegue(withIdentifier: "NewList", sender: self)

    }
    
    @IBAction func Cancelexit(_ sender: Any) {
        save = false;
        self.performSegue(withIdentifier: "NewList", sender: self)
    }
}
