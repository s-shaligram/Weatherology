//
//  ViewController.swift
//  Lab3-1121367
//
//  Created by Sameer Shaligram on 2023-03-20.
//

import UIKit
import CoreLocation
import MapKit

class MainScreen: UIViewController, UITextFieldDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var SearchTextField: UITextField!
    
    @IBOutlet weak var weatherConditionImage: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var temperatureSwitch: UISwitch!
    
    @IBOutlet weak var feelsLikeTemp: UILabel!
    
    @IBOutlet weak var uvDetails: UILabel!
    
    @IBOutlet weak var windSpeedMPH: UILabel!
    
    @IBOutlet weak var humidity: UILabel!
    
    @IBOutlet weak var localTime: UILabel!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    let listOfCondition:[Int:String] =
        [
            
            1000:"sun.min.fill"
            ,
            
            1003:"cloud.sun"
            ,
            1006:"smoke.fill"
            ,
            1009:"cloud.sun.rain.fill"
            ,
            1030:"sun.haze.fill"
            ,
            1063:"cloud.drizzle"
            ,
            1066:"cloud.snow"
            ,
            1069:"cloud.sleet"
            ,
            1072:"cloud.sleet"
            ,
            1087:"cloud.bolt.fill"
            ,
            1114:
                "cloud.sleet.circle"
            ,
            1117:
                "cloud.sleet.fill"
            ,
            1135:
               "smoke.fill"
            ,
            1147:
                 "smoke.circle.fill"
            ,
            1150:
                "cloud.hail"
            ,
            1153:"cloud.hail.circle"
            ,
            1168:
                "cloud.sleet"
            ,
            1171:"cloud.sleet.fill"
            ,
            1180:"cloud.drizzle"
            ,
            1183:"cloud.rain"
            ,
            1186:"cloud.heavyrain.fill"
            ,
            1189:"cloud.drizzle.circle"
            ,
            1192:"cloud.rain.fill"
            ,
            1195: "cloud.heavyrain.fill"
            ,
            1198:"cloud.hail"
            ,
            1201:"cloud.hail.fill"
            ,
            1204:"cloud.rain.circle"
            ,
            1207:
                "cloud.heavyrain.fill"
            ,
            1210:"cloud.hail.circle"
            ,
            1213:
               "cloud.snow"
            ,
            1216:
                 "cloud.hail.circle.fill"
            ,
            1219:
                "cloud.hail"
            ,
            1222:
                "cloud.snow.fill"
            ,
            1225:
                 "cloud.hail.circle.fill"
            ,
            1237:
                "cloud.sleet.circle.fill"
            ,
            1240:
                "cloud.drizzle.circle"
            ,
            1243:
                 "cloud.hail"
            ,
            1246:
                "cloud.snow"
            ,
            1249:
                "cloud.snow"
            ,
            1252:"cloud.snow.circle.fill"
            ,
            1255:"cloud.snow"
            ,
            1258:"cloud.snow.fill"
            ,
            1261:"cloud.sleet"
            ,
            1264:"cloud.sleet.circle.fill"
            ,
            1273:"cloud.bolt.rain"
            ,
            1276:"cloud.bolt.rain.fill"
            ,
            1279: "cloud.bolt.fill"
            ,
            1282:"cloud.heavyrain",
            
            
        ]

    var locationManager:CLLocationManager!
    var lat: Double?
    var long: Double?
    var dataTemp: String?
    var dataLoc: String?
    var tempF: Float?
    var tempC: Float?
    var codeW: Int?
    var fTempC: Float?
    var fTempF: Float?
    var errorCode: Int?
    var errorMessage: String?
    
    private var historyScreen = "gotoHistoryScreen"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SearchTextField.delegate = self
        temperatureSwitch.isOn = false
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        loadWeather(search: SearchTextField.text)
        textField.endEditing(true)
        // labelField.endEditing(true)
//        imgField.endEditing(true)
        print(textField.text ?? "")
        return true
    }
    
    private func displayImageForWeather(){
        let config = UIImage.SymbolConfiguration(paletteColors: [
            .systemRed, .systemTeal, .systemYellow])

        weatherConditionImage.preferredSymbolConfiguration = config
//        print(codeW)
        if let code = codeW {
            print(code)
            weatherConditionImage.image = UIImage(systemName: listOfCondition[code] ?? "sun.min")
        }
        
    }
    
    @IBAction func onHistoryClick(_ sender: UIButton) {
        handleHistorySegue()
    }
    
    private func handleHistorySegue(){
        performSegue(withIdentifier: historyScreen, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == historyScreen {
            // Navigating to Add Location Screen
            _ = segue.destination as! HistoryScreen
            
        }
    }
    
    @IBAction func onTempSwitched(_ sender: UISwitch) {
        if sender.isOn {
            temperatureLabel.text = "\(tempF ?? 0) F"
            feelsLikeTemp.text = "Feels Like: \(fTempF ?? 0) F"
            } else {
                temperatureLabel.text = "\(tempC ?? 0) C"
                feelsLikeTemp.text = "Feels Like: \(fTempC ?? 0) C"
            }
    }
    
    @IBAction func onLocationClicked(_ sender: UIButton) {
        
        locationManager = CLLocationManager()
            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringVisits()
        locationManager.startMonitoringSignificantLocationChanges()
            locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

//        isAuthorizedtoGetUserLocation()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.startUpdatingLocation()
            }
        }
        
        let query: String = "\(lat ?? 43.014924),\(long ?? -81.198652)"
        
        loadWeather(search: query)

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation :CLLocation = locations[0] as CLLocation

        print("user latitude = \(userLocation.coordinate.latitude)")
        lat = userLocation.coordinate.latitude
        print("user longitude = \(userLocation.coordinate.longitude)")
        long = userLocation.coordinate.longitude

//        CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,longitude: userLocation.coordinate.longitude)

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)

//                self.locationLabel.text = "\(placemark.locality!), \(placemark.administrativeArea!), \(placemark.country!)"
                self.locationLabel.text = "\(placemark.locality!)"
                self.SearchTextField.text = "\(placemark.locality!)"
            }
        }

    }
    
//    func isAuthorizedtoGetUserLocation() {
//
//        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
//            locationManager.requestWhenInUseAuthorization()
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }

    private func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error \(error)")
    }

    
    @IBAction func onSearchTapped(_ sender: UIButton) {
//        print(SearchTextField.text)
        loadWeather(search:SearchTextField.text)
    }
    
    private func loadWeather(search: String?){
        
        guard let search = search else{
            return
        }
        
        guard let url = getURL(query: search) else{
            return
        }
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            // network call ended
            print("network call completed")
            
            guard error == nil else {
                print("Received error!")
                return
            }
            
            guard let data = data else{
                print("No data!")
                return
            }
            
            if let weatherResponse = self.parseJSON(data: data){
//                self.dataField = data
                print(weatherResponse.location.name)
                print(weatherResponse.current.temp_c)
                
                DispatchQueue.main.async {
                    self.locationLabel.text = "\(weatherResponse.location.name), \(weatherResponse.location.region), \(weatherResponse.location.country)"
                    self.tempC = (weatherResponse.current.temp_c)
                    self.tempF = (weatherResponse.current.temp_f)
                    
                    self.temperatureLabel.text = "\(weatherResponse.current.temp_c) C"
                    self.codeW = (weatherResponse.current.condition.code)
//                    print(self.codeW as Any)
                    print("Weather code: \(weatherResponse.current.condition.code)")
//                    print(weatherResponse.current.wind_mph, weatherResponse.current.humidity, weatherResponse.current.feelslike_c, weatherResponse.current.feelslike_f)
                    
                    self.humidity.text = "Humidity: \(weatherResponse.current.humidity)"
                    
                    self.windSpeedMPH.text = "Wind(mph):  \(weatherResponse.current.wind_mph)"
                    
                    self.uvDetails.text = "UV: \(weatherResponse.current.uv)"
                    
                    self.feelsLikeTemp.text = "Feels Like: \(weatherResponse.current.feelslike_c) C"
                    
                    self.fTempC = weatherResponse.current.feelslike_c
                    
                    self.fTempF = weatherResponse.current.feelslike_f
                    
                    self.localTime.text = "\(weatherResponse.location.localtime)"
                    
                    self.weatherLabel.text = weatherResponse.current.condition.text
                    
                    self.displayImageForWeather()
                    self.temperatureSwitch.isOn = false
                }
            }
            
        }
        
        dataTask.resume()
    }
    
    
    private func parseJSON(data: Data) -> WeatherResponse?{
        let decoder = JSONDecoder()
        var weather: WeatherResponse?
        
        do{
            weather = try decoder.decode(WeatherResponse.self, from: data)
        } catch{
            print("Error decoding")
        }
        
        return weather
    }
    
    
    private func getURL(query: String) -> URL?{
        
        let baseURL = "https://api.weatherapi.com/v1/"
        let currentEndpoint = "current.json"
        let apiKey = "1bd7fc3e9f134e7986711555223210"
//        1bd7fc3e9f134e79867115552232104
        // query = "q=Toronto"
        guard let url = "\(baseURL)\(currentEndpoint)?key=\(apiKey)&q=\(query)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else{
                return nil
            }
        
        print(url)
        return URL(string: url)
    }
}

struct WeatherResponse: Decodable{
    let location: Location
    let current: Weather
}

struct Location: Decodable{
    let name: String
    let region: String
    let country: String
    let localtime: String
}

struct Weather: Decodable{
    let temp_c: Float
    let temp_f: Float
    let condition: Condition
    let wind_mph: Float
    let humidity: Int
    let feelslike_c: Float
    let feelslike_f: Float
    let uv: Float
}

struct Condition: Decodable{
    let text: String
    let code: Int
}

//struct WeatherError: Decodable{
//    let error: Error
//}

struct Error: Decodable{
    let code: Int
    let message: String
}

/*
 {
     "location": {
         "name": "Toronto",
         "region": "Ontario",
         "country": "Canada",
         "lat": 43.67,
         "lon": -79.42,
         "tz_id": "America/Toronto",
         "localtime_epoch": 1679345294,
         "localtime": "2023-03-20 16:48"
     },
     "current": {
         "last_updated_epoch": 1679345100,
         "last_updated": "2023-03-20 16:45",
         "temp_c": 5.0,
         "temp_f": 41.0,
         "is_day": 1,
         "condition": {
             "text": "Sunny",
             "icon": "//cdn.weatherapi.com/weather/64x64/day/113.png",
             "code": 1000
         },
         "wind_mph": 17.4,
         "wind_kph": 28.1,
         "wind_degree": 210,
         "wind_dir": "SSW",
         "pressure_mb": 1019.0,
         "pressure_in": 30.09,
         "precip_mm": 0.0,
         "precip_in": 0.0,
         "humidity": 65,
         "cloud": 0,
         "feelslike_c": 0.8,
         "feelslike_f": 33.4,
         "vis_km": 14.0,
         "vis_miles": 8.0,
         "uv": 3.0,
         "gust_mph": 17.7,
         "gust_kph": 28.4
     }
 }
 */
