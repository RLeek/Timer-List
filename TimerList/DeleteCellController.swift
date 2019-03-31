//
//  DeleteCellController.swift
//  TimerList
//
//  Created by Ricky Liu on 10/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit

class DeleteCellController: UIViewController {

    //MARK: Class Variables
    var name: String = "";
    var selected: IndexPath = [0,1];
    var delete: Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Notifycell.text = "\"" + name + "\"" + "will be permanently deleted"
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var Notifycell: UILabel!
    

    
    @IBAction func Delete(_ sender: Any) {
        delete = true;
        performSegue(withIdentifier: "DeleteBack", sender: self);
        
    }
    
    
    @IBAction func Cancel(_ sender: Any) {
        delete = false;
        performSegue(withIdentifier: "DeleteBack", sender: self);

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
