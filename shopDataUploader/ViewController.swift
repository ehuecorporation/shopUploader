//
//  ViewController.swift
//  shopDataUploader
//
//  Created by 蕭　喬仁 on 2017/03/23.
//  Copyright © 2017年 蕭　喬仁. All rights reserved.
//

import UIKit
import NCMB

public struct shop {
    
    public var objectID: String = ""
    public var shopName: String = ""
    public var shopNumber: Int = 0
    public var shopLat: Double = 0
    public var shopLon: Double = 0
    public var shopGeo: NCMBGeoPoint = NCMBGeoPoint()
    public var openHours: String = ""
    public var restDay: String = ""
    
}


class ViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var nowIndex: UITextField!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var openHours: UITextView!
    @IBOutlet weak var restDay: UITextView!
    
    @IBAction func hyde(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func back(_ sender: UIButton) {
        index -= 1
        if index == 0 {
            index = 1
        }
        loadView()
        viewDidLoad()
    }
    @IBAction func uploadData(_ sender: UIButton) {
        //新規データを一件登録する
        let targetShopName = self.shopName.text!
        let targetOpenHours = self.openHours.text
        let targetRestDay = self.restDay.text
        let targetLon = self.lon
        let targetLat = self.lat
        let number = self.index
        
        let geoPoint = NCMBGeoPoint()
        geoPoint.latitude = targetLat
        geoPoint.longitude = targetLon
        
        dataList.remove(at: index)
        
        var saveError: NSError? = nil
        
        let obj: NCMBObject = NCMBObject(className: "restaurantList")
        obj.setObject(targetShopName, forKey: "shopName")
        obj.setObject(targetOpenHours, forKey: "openHours")
        obj.setObject(targetRestDay, forKey: "restDay")
        obj.setObject(geoPoint, forKey: "geoPoint")
        obj.setObject(number, forKey: "number")
        obj.save(&saveError)
        
        
        if saveError == nil {
            print("success save data.")
        } else {
            print("failure save data.\(saveError)")
        }
    
        next(UIButton.init())
    }
    
    @IBAction func next(_ sender: UIButton) {
        index += 1
        loadView()
        viewDidLoad()
    }
    
    @IBAction func go(_ sender: UIButton) {
        index = Int(nowIndex.text!)!
        loadView()
        viewDidLoad()
    }
    
    var index = 1
    var firstAppear = true
    
    var lon = 0.0
    var lat = 0.0
    
    var dataList:[String] = []
    
    let fileManager = FileManager()
    //CSVファイルの保存先
    var userPath:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            //CSVファイルのパスを取得する。
            let csvPath = Bundle.main.path(forResource: "edited_data", ofType: "csv")
            userPath = csvPath!
            
            //CSVファイルのデータを取得する。
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf16)
            
            //改行区切りでデータを分割して配列に格納する。
            dataList = csvData.components(separatedBy:"*")
            
        } catch {
            print(error)
        }
        
        if firstAppear {
            print("here")
            findIndex()
            firstAppear = false
        } else {
            showShopData(index)
        }
        
        nowIndex.text = index.description
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showShopData(_ index: Int) {
        let dataDetail = dataList[index].components(separatedBy:",")
        var openHours_content = dataDetail[3]
        let startIndex = openHours_content.index(openHours_content.startIndex, offsetBy: 0)
        openHours_content.remove(at: startIndex)
        if openHours_content[startIndex] == "[" {
            
        } else {
            openHours_content.remove(at: startIndex)
        }
        let endIndex = openHours_content.index(openHours_content.endIndex, offsetBy: -1)
        openHours_content.remove(at: endIndex)
        shopName.text = dataDetail[0]
        openHours.text = openHours_content
        restDay.text = dataDetail[4]
        self.lat = Double(dataDetail[1])!
        self.lon = Double(dataDetail[2])!
    }
    
    func findIndex() {
        let query: NCMBQuery = NCMBQuery(className: "restaurantList")
        query.order(byDescending: "number")
        
        var tmpArray = [shop]()
        print("find index")
        
        query.findObjectsInBackground({(objects,  error) in
        
            if error == nil {
                if let response = objects {
                    if (response.count) > 0 {
                        
                        for i in 0 ..< 1 {
                            let targetMemoData: AnyObject = response[i] as AnyObject
                            var shopData = shop()
                            shopData.objectID = (targetMemoData.object(forKey: "objectId") as? String)!
                            shopData.shopName = (targetMemoData.object(forKey: "shopName") as? String)!
                            shopData.shopNumber = (targetMemoData.object(forKey: "number") as? Int)!
                            shopData.openHours = (targetMemoData.object(forKey: "openHours") as? String)!
                            shopData.restDay = (targetMemoData.object(forKey: "restDay") as? String)!
                            shopData.shopGeo = (targetMemoData.object(forKey: "geoPoint") as? NCMBGeoPoint)!
                            shopData.shopLon = shopData.shopGeo.longitude
                            shopData.shopLat = shopData.shopGeo.latitude
                            print(shopData)
                            tmpArray.append(shopData)
                            self.index = shopData.shopNumber + 1
                            self.loadView()
                            self.viewDidLoad()
                        }
                    } else {
                        print("there are no restaurant data")
                    }// response.count end
                } else {
                    print("通信エラー")
                }// opt bind objects
            } else {
                var message = "Unknown error."
                if let description = error?.localizedDescription {
                        message = description
                }
                print(message)
                return
            } // errors end
                
        }) // findObjects end
    }

}

extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return self.layer.borderWidth
        }
        set {
            self.layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set {
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
}

