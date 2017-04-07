//
//  ViewController.swift
//  shopDataUploader
//
//  Created by 蕭　喬仁 on 2017/03/23.
//  Copyright © 2017年 蕭　喬仁. All rights reserved.
//

import UIKit
import NCMB

class ViewController: UIViewController {

    @IBOutlet weak var nowIndex: UITextField!
    @IBOutlet weak var shopName: UITextField!
    @IBOutlet weak var openHours: UITextView!
    @IBOutlet weak var restDay: UITextView!
    
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
        
        var geoPoint = NCMBGeoPoint()
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
        
        loadView()
        viewDidLoad()
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
        nowIndex.text = index.description
        print(index)
        print(dataList[index])
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

