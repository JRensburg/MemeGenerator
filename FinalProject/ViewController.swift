//
//  ViewController.swift
//  FinalProject
//
//  Created by Jacobus Janse van Rensburg on 4/25/17.
//  Copyright © 2017 Jaco van  Rensburg. All rights reserved.
//

import UIKit
protocol ViewControllerDelegate:class {
    func animateView()
}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var myView: BackgroundView!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    var theMemes:([String],[String],[String],[UIImage?]) = ([],[],[],[])
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let indicator = ActivityView()
        self.table.alpha = 0
        self.topText.isHidden = true
        self.bottomText.isHidden = true
        loadMaymays(completion: {(content:NSArray) -> Void in
            for array in content.enumerated() {
                indicator.stopAnimating()
                let parse = array.element as! [String:Any]
                self.theMemes.0.append(parse["id"] as! String)
                self.theMemes.1.append(parse["name"] as! String)
                self.theMemes.2.append(parse["url"] as! String)
                self.theMemes.3.append(nil)
                self.loadImage(index: array.offset)
            }
            self.table.delegate = self
            self.table.dataSource = self
            self.table.isHidden = false
            self.animateBttn()
            self.table.reloadData()
        })

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func ActivityView()->UIActivityIndicatorView{
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        indicator.center = view.center
        view.addSubview(indicator)
        return indicator
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return theMemes.0.count
    }
    
    func loadImage(index:Int) -> Void {
        let imageurl = URL(string: theMemes.2[index])
        let task = URLSession.shared.dataTask(with: imageurl!, completionHandler: { data,response,error in
            guard let data = data, error == nil else{
                print("error\(error!)")
                return
            }
            do{
                let image:UIImage = UIImage(data: data)!
                self.theMemes.3[index] = image
            }
        })
        task.resume()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! MemeTableViewCell
         let attribs = [ NSStrokeColorAttributeName : UIColor.black, NSForegroundColorAttributeName : UIColor.white, NSStrokeWidthAttributeName : -1.0 ] as [String : Any]
        cell.label.attributedText = NSAttributedString(string:theMemes.1[indexPath.row] , attributes : attribs)
        if(theMemes.3[indexPath.row] == nil){
            table.reloadData()
        }
        else{
            cell.memeView.image = theMemes.3[indexPath.row]
            if cell.memeView.subviews.isEmpty{ //avoids adding blur effect multiple times
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds            
            cell.memeView.addSubview(blurEffectView)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let img = table.cellForRow(at: indexPath) as! MemeTableViewCell
        for subview in img.memeView.subviews {
            if subview is UIVisualEffectView {
                subview.removeFromSuperview()
            }
        }
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = table.cellForRow(at: indexPath) as? MemeTableViewCell{
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        cell.memeView.addSubview(blurEffectView)
        }
    }
    
    func animateBttn(){
        UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            self.bottomText.isHidden = false
            self.topText.isHidden = false
            self.topText.center.x -= self.view.bounds.width
            self.bottomText.center.x += self.view.bounds.width
            self.table.alpha = 100
        },completion: nil)
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if segue.identifier == "segue1" && table.indexPathForSelectedRow != nil {
            let vc: MayMayViewController = segue.destination as! MayMayViewController
            vc.info.2 = theMemes.0[(table.indexPathForSelectedRow?.row)!]
            vc.info.1 = bottomText.text!
            vc.info.0 = topText.text!
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


}

