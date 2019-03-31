//
//  FirstTable.swift
//  TimerList
//
//  Created by Ricky Liu on 7/2/19.
//  Copyright © 2019 Ricky Liu. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    @IBOutlet weak var Title: UILabel!
}


class FirstTable: UITableViewController {

    // MARK: Data
    var Timerlists:[timerlist] = [];
    var selected:IndexPath = [0,1];
    
    // MARK: Navigation
    override func viewDidLoad() {
        super.viewDidLoad()
        let navbar = self.navigationController!.navigationBar
        navbar.shadowImage = #imageLiteral(resourceName: "greycolor.png")
        self.tableView.isEditing = false;
        Timerlists = loadme();
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    func loadme()-> [timerlist] {
        let decoder = JSONDecoder();
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("untitled.json");
        let data = try? Data(contentsOf: url);
        if data == nil {
            return [];
        }
       
        if let newvalue = try? decoder.decode([timerlist].self, from: data!) {
            return newvalue;
        } else {
            return [];
        }
    }
    
    func saveme() {
        let encoder = JSONEncoder();
        let data = try! encoder.encode(Timerlists);
        let url = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("untitled.json");
        try! data.write(to: url);

    }
    
    @IBAction func unwindToFirstTable(_ unwindSegue: UIStoryboardSegue) {
        let sender = unwindSegue.source as! NewCellController
        if sender.save == true {
            Timerlists.append(timerlist(name: sender.TextField.text!));
            saveme()

            tableView.reloadData();
        }
    }
    
    @IBAction func unwindToEditTable(_ unwindSegue: UIStoryboardSegue) {
        let sender = unwindSegue.source as! EditCellController
        if sender.save == true {
            Timerlists[sender.row].changename(name: sender.TextField.text!);
            saveme()
            tableView.reloadData();
        }
    }
    
    @IBAction func unwindToSecondaryTable(_ unwindSegue: UIStoryboardSegue) {
        saveme()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Timerlists.count;
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "maincell", for: indexPath) as! MainCell
        cell.Title?.text = Timerlists[indexPath.row].getname();
        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action1 = UIContextualAction(style: .normal, title: "Edit") {(action,sourceView,completionHandler) in
            self.selected = indexPath;
            self.performSegue(withIdentifier: "EditSegueForward", sender: self);
        }
            
        
        let action2 = UIContextualAction(style: .normal, title: "Delete") {(action,sourceView,completionHandler) in
            let deletepop = UIAlertController(title:nil , message: "\"" + self.Timerlists[indexPath.row].getname() + "\"" + "will be permanently deleted", preferredStyle: .actionSheet);
            deletepop.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                self.Timerlists.remove(at: indexPath.row)
                tableView.setEditing(false, animated: true)
                tableView.deleteRows(at: [indexPath], with: .fade
                )
                self.saveme()
            }))
            
            deletepop.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:{ _ in
                tableView.setEditing(false, animated: true)

            }));
            
            self.present(deletepop, animated: true, completion: nil);

        }
        action1.backgroundColor = #colorLiteral(red: 0.05803687125, green: 0.4780174494, blue: 0.8318818808, alpha: 1)
        action2.backgroundColor = #colorLiteral(red: 0.8318818808, green: 0.2878107509, blue: 0.2076191494, alpha: 1)
        action2.image = #imageLiteral(resourceName: "cross.png");
        action1.image = #imageLiteral(resourceName: "final_wheel.png");
        let configuration = UISwipeActionsConfiguration(actions: [action2,action1])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EditSegueForward") {
            let nc = segue.destination as! UINavigationController;
            let vc = nc.topViewController as! EditCellController;
            vc.row = selected.row
            vc.initialname = Timerlists[selected.row].getname();
        }
        if (segue.identifier == "Timerforward") {
            let nc = segue.destination as! TimerTable;
            nc.timerlist = Timerlists[selected.row];
        }
 
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DID THIS RUN");
        self.selected = indexPath
        self.performSegue(withIdentifier: "Timerforward", sender: self);
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let element = Timerlists.remove(at: fromIndexPath.row);
        Timerlists.insert(element, at: to.row);

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
