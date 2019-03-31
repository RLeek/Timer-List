//
//  EditCellController.swift
//  TimerList
//
//  Created by Ricky Liu on 9/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit

class EditCellController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var Save: UIBarButtonItem!
    @IBOutlet weak var TextField: UITextField!
    
    var initialname: String = "";
    var row: Int = -1;
    var save: Bool = false;
    

    override func viewDidLoad() {
        super.viewDidLoad()
        Save.isEnabled = false;
        let navbar = self.navigationController!.navigationBar
        navbar.shadowImage = #imageLiteral(resourceName: "greycolor");
        TextField.text = initialname;
        TextField.returnKeyType = UIReturnKeyType.done
        self.TextField.delegate = self

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func Validation(_ sender: Any) {
        if (TextField.text != "") {
            Save.isEnabled = true;
        } else {
            Save.isEnabled = false;
        }
    }
    
    
    @IBAction func SaveButton(_ sender: Any) {
        save = true;
        self.performSegue(withIdentifier: "EditSegue", sender: self)
    }
    
    
    
    @IBAction func CancelButton(_ sender: Any) {
        save = false;
        self.performSegue(withIdentifier: "EditSegue", sender: self)
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
