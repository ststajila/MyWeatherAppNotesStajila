//
//  ViewController.swift
//  MyWeatherAppNotesStajila
//
//  Created by STANISLAV STAJILA on 1/8/24.
//

struct WindInfo: Codable{
    var speed: Double
    var deg: Int
}


import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var highTempLabel: UILabel!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunsetTime: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    
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
                                    self.humidityLabel.text = "Humidity: \(humidity)%"
                                }
                            }
                        }
                        
                        
                        if let sys = jsonObj.value(forKey: "sys") as? NSDictionary{
                            if let sunsetTime = sys.value(forKey: "sunset") as? Double{
                                DispatchQueue.main.async{
                                    let date = Date(timeIntervalSince1970: sunsetTime)
                                    self.sunsetTime.text = "Sunset Time: \(date.formatted(date: .omitted, time: .shortened))"
                                }
                            }
                        }
                            
                        if let wind = jsonObj.value(forKey: "wind") as? NSDictionary{
                            if let speed = wind.value(forKey: "speed") as? Double{
                                DispatchQueue.main.async{
                                    self.windSpeedLabel.text = "Wind Speed: \(speed) mph"
                                }
                                
                                if let direction = wind.value(forKey: "deg") as? Double {
                                    DispatchQueue.main.async{
                                        self.windDirectionLabel.text = "Wind Direction: \(self.windDirection(deg: direction))"
                                    }
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
    
    func windDirection(deg: Double) -> String{
        if deg == 0 || deg < 22.5{
            return "N"
        } else if deg >= 22.5 && deg < 45{
            return "NNE"
        } else if deg == 45 || deg < 67.5{
            return "NE"
        } else if deg >= 67.5 && deg < 90{
            return "ENE"
        } else if deg == 90 || deg < 112.5{
            return "E"
        } else if deg >= 112.5 && deg < 135{
            return "ESE"
        } else if deg == 135 || deg < 157.5{
            return "SE"
        } else if deg >= 157.5 && deg < 180{
            return "SSE"
        }else if deg == 180 || deg < 202.5{
            return "S"
        } else if deg >= 202.5 && deg < 225{
            return "SSW"
        } else if deg == 225 || deg < 247.5{
            return "SW"
        } else if deg >= 247.5 && deg < 270{
            return "WSW"
        }else if deg == 270 || deg < 292.5{
            return "W"
        } else if deg >= 292.5 && deg < 315{
            return "WNW"
        } else if deg == 315 || deg < 337.5{
            return "NW"
        } else if deg >= 337.5 && deg < 360{
            return "NNW"
        }else if deg == 360{
            return "N"
        } else{
            return "Out of Range"
        }
    }
}
