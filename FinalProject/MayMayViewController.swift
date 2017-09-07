//
//  MayMayViewController.swift
//  FinalProject
//
//  Created by Jacobus Janse van Rensburg on 4/25/17.
//  Copyright © 2017 Jaco van  Rensburg. All rights reserved.
//

import UIKit

class MayMayViewController: UIViewController {

    var info:(top:String,bottom:String,id:String) = ("","","")
    @IBOutlet var mayMay: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doTheThing()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func doTheThing(){
        var request = URLRequest(url: URL(string: "https://api.imgflip.com/caption_image")!)
        request.httpMethod = "POST"
        let postString:String = makeString(id: info.2,text0: info.0,text1: info.1)
        
        request.httpBody = postString.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else { // check for fundamental networking error
                print("error=\(error!)")
                return
            }
            
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(response!)")
            }
            do{
                let parseData = try JSONSerialization.jsonObject(with: data, options:[]) as! [String:Any]
                let responseString = String(data: data, encoding: .utf8)
                print("responseString = \(responseString!)")
                if parseData["success"] as! Bool {
                    let theData = parseData["data"] as? [String:Any]
                    if let img = theData?["url"] as? String{
                        if let checkedUrl = URL(string: img) {
                            self.mayMay.contentMode = .scaleAspectFit
                            self.downloadImage(url: checkedUrl)
                        }
                    }
                }
            }catch let error as NSError {
                print(error)
            }
        }
        //self.textfield.text = textfield
        task.resume()
    }
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { () -> Void in
                let img = UIImage(data:data)
                let imgSize:CGSize = img!.size
                let width = imgSize.width * (self.view.frame.width/imgSize.width)
                let height = imgSize.height * (self.view.frame.width/imgSize.width) //* (self.view.frame.height/imgSize.height)
                UIGraphicsBeginImageContext(CGSize(width:width, height:height))
                img?.draw(in: CGRect(x:0,y:0,width:width,height:height))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                self.mayMay.image = newImage!
                self.mayMay.center = self.view.center
            
            }
        }
    }
    func makeString(id:String,text0:String,text1:String)->String{
        var formattedString:String
        formattedString="template_id=\(id)&username=maymays&password=maymays&text0=\(text0)&text1=\(text1)"
        return formattedString
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
