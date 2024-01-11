//
//  ViewController.swift
//  MyWeatherAppNotesStajila
//
//  Created by STANISLAV STAJILA on 1/8/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunsetTime: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getWeather()
    }

    func getWeather(){
       //creating a session
        let session = URLSession.shared

    // creating a URL for api call (use your API key, add location of the place using lat & long of a place, change units if applicable)
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=42.243420&lon=-88.316978&units=imperial&appid=1942debaa31f5e108a4255b2488e7584")
    
        // Making an API call and creating data in the completion handler
        let dataTask = session.dataTask(with: weatherURL!){
            //completion handler: happens on a different thread, could take time to take data
            (data: Data?, response: URLResponse?, error: Error?) in
            
            if let e = error {
                print("Error:\n\(e)")
            } else {
                // if there is data
                if let d = data {
                    // convert data to json Object
                    if let jsonObj = try? JSONSerialization.jsonObject(with: d, options: .allowFragments) as? NSDictionary {
                        
                        // print the jsonObj to see structure
                        print(jsonObj)
                        
                        // needs as since return type Any
                        if let main = jsonObj.value(forKey: "main") as? NSDictionary {
                            
                            if let temp = main.value(forKey: "temp") as? Double{
                                //Making it happen on the main thread, gets data before shows up on the label
                                DispatchQueue.main.async {
                                    self.tempLabel.text = "\(temp)"
                                
                                }
                            }
                            
                            if let highTemp = main.value(forKey: "temp_max") as? Double{
                                DispatchQueue.main.async{
                                    self.highTempLabel.text = "High: \(highTemp)"
                                }
                                
                                if let lowTemp = main.value(forKey: "temp_min") as? Double{
                                    DispatchQueue.main.async{
                                        self.lowTempLabel.text = "Low: \(lowTemp)"
                                    }
                                }
                            }
                            
                            if let humidity = main.value(forKey: "humidity") as? Double{
                                DispatchQueue.main.async{
                                    self.humidityLabel.text = "Humidity: \(humidity)"
                                }
                            }
                        }
                        
                        
                        if let sys = jsonObj.value(forKey: "sys") as? NSDictionary{
                            if let sunsetTime = sys.value(forKey: "sunset") as? Int{
                                DispatchQueue.main.async{
                                    self.sunsetTime.text = "Sunset Time: \(sunsetTime)"
                                }
                            }
                        }
                        
                        
                        
                    }
                }
            }
        }
                                    
            // Tryes to get the data each time!
                    dataTask.resume()
        }
}

