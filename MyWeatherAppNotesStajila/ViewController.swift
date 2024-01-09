//
//  ViewController.swift
//  MyWeatherAppNotesStajila
//
//  Created by STANISLAV STAJILA on 1/8/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var weatherLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getWeather()
    }

    func getWeather(){
       //creating a session
        let session = URLSession.shared

    // creating a URL for api call (use your API key)
        let weatherURL = URL(string: "http://api.openweathermap.org/data/2.5/weather?lat=44.34&lon=10.99&units=imperial&appid={1942debaa31f5e108a4255b2488e7584}"
    
        // Making an API call and creating data in the completion handler
        let dataTask = session.dataTask(with: weatherURL){
            //completion handler: happens on a different thread, could take time to take data
            (data: Data?, response: URLResponse?, error: Error?) in

                        if let error = error {
                            print("Error:\n\(error)")
                        } else {
                            // if there is data
                            if let data = data {
                                // convert data to json Object
                                if let jsonObj = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary {
                                    
                                    // print the jsonObj to see structure
                                    print(jsonObj)
                                    
                                    // find main key and get all the values as a dictionary
                                    if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                                        
                                        // get the value for the key temp
                                        if let temperature = mainDictionary.value(forKey: "temp") {
                                            // make it happen on the main thread so it happens during viewDidLoad
                                            DispatchQueue.main.async {
                                                // making the value show up on a label
                                                self.weatherLabel.text = "result \(temperature)"
                                            }
                                          
                                        } else {
                                            print("Error: unable to find temperature in dictionary")
                                        }
                                    } else {
                                        print("Error: unable to convert json data")
                                    }
                                }
                                else {
                                    print("Error: Can't convert data to json object")
                                }
                            }else {
                                print("Error: did not receive data")
                            }
                        }
                    }

                    dataTask.resume()
        }
}

