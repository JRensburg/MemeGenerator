

//
//  TableViewController.swift
//  FinalProject
//
//  Created by Jaco Van Rensburg on 4/28/17.
//  Copyright © 2017 Jaco van  Rensburg. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
  var theMemes:([String],[String]) = ([],[])
    
    @IBOutlet weak var bottomView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 100);

        loadMaymays(completion: {(content:NSArray) -> Void in
            for array in content {
                let parse = array as! [String:Any]
                self.theMemes.0.append(parse["id"] as! String)
                self.theMemes.1.append(parse["name"] as! String)
            }
                self.tableView.reloadData()
            for item in self.theMemes.1{
                print(item)
            }
        })

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return theMemes.1.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        cell.textLabel?.text = theMemes.1[indexPath.row]
    
        // Configure the cell...
        
        return cell
    }
    /*
    func animateBttn(){
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.topText.center.x -= self.view.bounds.width
            self.bottomText.center.x += self.view.bounds.width
        },completion: nil)
    }
     */
    @IBAction func about(_ sender: Any) {
        performSegue(withIdentifier: "segue1", sender: sender)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "segue1" {
            let vc: MayMayViewController = segue.destination as! MayMayViewController
            // vc.info.2 = theMemes.0[memePicker.selectedRow(inComponent: 0)]
            //vc.info.1 = bottomText.text!
            //vc.info.0 = topText.text!
        }
    }
    
    func loadMaymays(completion: @escaping (_ theMemes:NSArray)->Void){
        var request = URLRequest(url: URL(string:"https://api.imgflip.com/get_memes")!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error  in
            guard let data = data, error == nil else{
                print("error=\(error!)")
                return
            }
            if let httpStatus = response as? HTTPURLResponse , httpStatus.statusCode != 200 {
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            do{
                let parseData = try JSONSerialization.jsonObject(with: data, options:[]) as! [String:Any]
                if (parseData["success"] as? Bool)!{
                    let response2 = parseData["data"] as! [String:Any]
                    let response3 = response2["memes"] as? NSArray
                    completion(response3!)
                }
            }
            catch let error as NSError {
                print(error)
            }
        }
        task.resume()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
