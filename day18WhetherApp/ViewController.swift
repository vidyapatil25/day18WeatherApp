//
//  ViewController.swift
//  day18WhetherApp
//
//  Created by Felix-ITS016 on 26/12/19.
//  Copyright © 2019 Felix. All rights reserved.
//

import UIKit
import MapKit
class ViewController: UIViewController,MKMapViewDelegate   ,UITextFieldDelegate {
    // https://samples.openweathermap.org/data/2.5/weather?lat=35&lon=139&appid=c1a5cafcc7ba92a8e8f44983a4a84200
    @IBOutlet var enterCity: UITextField!
    @IBOutlet var labelDescription: UILabel!
    var lat = 0.0
    var lon = 0.0
    @IBOutlet var labelTemp: UILabel!
    
    @IBOutlet var labelhumidty: UILabel!
    enum  JsonErrors:String,Error
    {
        case responseError = "Response Error"
        case dataError = "Data Error"
        case ConversionError = "Conversion Error"
    }
  
    
    func Parsejson()
    {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=c1a5cafcc7ba92a8e8f44983a4a84200"
        let url:URL = URL(string: urlString)!
        let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession( configuration:sessionConfiguration)
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            do
            {
                guard let response   =  response else
                {
                    throw JsonErrors.responseError
                }
                guard let data = data else
                {
                    throw JsonErrors.dataError
                }
                guard let dic = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any] else
                {
                    throw JsonErrors.ConversionError
                }
                
                let weatherArray = dic["weather"] as! [[String:Any]]
                let weatherDic = weatherArray.first!
                    let description = weatherDic["description"] as! String
                    print(description)
                let mainDic = dic["main"] as! [String:Any]
                let temp = mainDic["temp"] as! Double
                let tempStr = String(temp)
                print(tempStr)
                let  humidity = mainDic["humidity"] as! Double
                let humidityStr = String(humidity)
                    print(humidityStr)
                DispatchQueue.main.async
                {
                    self.labelDescription.text = description
                    self.labelTemp.text = tempStr
                    self.labelhumidty.text = humidityStr
                }
            }
        catch let err
            {
                print(err)
            }
        }
        dataTask.resume()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let geo = CLGeocoder()
        geo.geocodeAddressString(enterCity.text!) { (placemarks, error) in
            let coordinate = placemarks?.first!.location?.coordinate
            self.lat = (coordinate?.latitude)!
            self.lon = (coordinate?.longitude)!
            //let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
           // let region = MKCoordinateRegion(center:coordinate!, span: span)
        }
        Parsejson()
        return true
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
}



