//
//  MapViewController.swift
//  Dreams
//
//  Created by SG on 2021/08/09.
//

import UIKit
import GoogleMaps

import UIKit
import GoogleMaps
import GooglePlaces
import Firebase


struct MyPlace {
    var name: String
    var lat: Double
    var long: Double
}

class MapViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate, GMSAutocompleteViewControllerDelegate, UITextFieldDelegate {
    
    let currentLocationMarker = GMSMarker()
    var locationManager = CLLocationManager()
    var chosenPlace: MyPlace?
    
    let customMarkerWidth: Int = 50
    let customMarkerHeight: Int = 70
    
//    var previewDemoData = [(title: "홍대 야구장", img: #imageLiteral(resourceName: "baseball2"), price: 10, Latitude: 37.551674944360386, longitude: 126.92498582698552),
//                           (title: "한강 야구장", img: #imageLiteral(resourceName: "baseball1"), price: 8, Latitude: 37.53296503864491, longitude: 126.92363728895141),
//                           (title: "용산 야구장", img: #imageLiteral(resourceName: "baseball3"), price: 12, Latitude: 37.529280811821046, longitude: 126.96860947233841)
//    ]

    var ref: DatabaseReference!
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var stadiumData: [(title: String, img: UIImage, price: Int, Latitude: Double, longitude: Double)] = []
    var stadiumImage: UIImage?
    var stadiumDataCnt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        self.view.backgroundColor = UIColor.white
        myMapView.delegate=self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.startMonitoringSignificantLocationChanges()
        
        setupViews()
        initGoogleMaps()
        txtFieldSearch.delegate=self
        ServerDataLoad()
    }
    
    
    func ServerDataLoad() {
        db.collection("Stadium").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                    
                    let info = document.data()
                    guard let title = info["title"] as? String else {return}
                    guard let price = info["price"] as? Int else {return}
                    guard let Latitude = info["Latitude"] as? Double else {return}
                    guard let Longitude = info["Longitude"] as? Double else {return}
                    
                    
                    // 이미지 저장
                    let islandRef = Storage.storage().reference().child("\(document.documentID).jpg")
                    // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
                    islandRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
                    if let error = error {
                    // Uh-oh, an error occurred!
                    print("error: \(error)")
                    } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
            
                        self.stadiumData.append((title: title, img: image ?? #imageLiteral(resourceName: "baseball3"), price: price, Latitude: Latitude, longitude: Longitude))
                        print("이미지 정보 값 \(image)")
                        }
                    }
             
                    
                  //  self.stadiumData.append((title: title, img: self.stadiumImage ?? #imageLiteral(resourceName: "baseball3"), price: price, Latitude: Latitude, longitude: Longitude))
                
                  print("검사  \(self.stadiumData)")
                    
                }
            }
            self.stadiumDataCnt = self.stadiumData.count ?? 0
            print("마지막 전체개수 \( self.stadiumDataCnt)")
        }
        
       
    }
    
    //MARK: textfield
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
    
    // MARK: GOOGLE AUTO COMPLETE DELEGATE
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        showPartyMarkers(lat: lat, long: long)
        
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        myMapView.camera = camera
      
        txtFieldSearch.text=place.formattedAddress
        chosenPlace = MyPlace(name: place.formattedAddress!, lat: lat, long: long)
        let marker=GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.title = "\(place.name)"
        marker.snippet = "\(place.formattedAddress!)"
        marker.map = myMapView
        
        self.dismiss(animated: true, completion: nil) // dismiss after place selected
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("ERROR AUTO COMPLETE \(error)")
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func initGoogleMaps() {
        let camera = GMSCameraPosition.camera(withLatitude: 28.7041, longitude: 77.1025, zoom: 17.0)
        self.myMapView.camera = camera
        self.myMapView.delegate = self
        self.myMapView.isMyLocationEnabled = true
    }
    
    // MARK: CLLocation Manager Delegate
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while getting location \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.delegate = nil
        locationManager.stopUpdatingLocation()
        let location = locations.last
        let lat = (location?.coordinate.latitude)!
        let long = (location?.coordinate.longitude)!
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 17.0)
        
        self.myMapView.animate(to: camera)
        
        showPartyMarkers(lat: lat, long: long)
    }
    
    // MARK: GOOGLE MAP DELEGATE
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return false }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.white, tag: customMarkerView.tag)
        
        marker.iconView = customMarker
        
        return false
    }
    
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return nil }
        let data = stadiumData[customMarkerView.tag]
        stadiumPreviewView.setData(title: data.title, img: data.img, price: data.price)
        return stadiumPreviewView
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let tag = customMarkerView.tag
       restaurantTapped(tag: tag)
    }
    
    func mapView(_ mapView: GMSMapView, didCloseInfoWindowOf marker: GMSMarker) {
        guard let customMarkerView = marker.iconView as? CustomMarkerView else { return }
        let img = customMarkerView.img!
        let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: img, borderColor: UIColor.darkGray, tag: customMarkerView.tag)
        marker.iconView = customMarker
    }
    
    func showPartyMarkers(lat: Double, long: Double) {
        myMapView.clear()
        let cnt = stadiumData.count
        for i in 0..<cnt {
        
            let latutude = stadiumData[i].Latitude
            let longitude = stadiumData[i].longitude
            
            let marker=GMSMarker()
            let customMarker = CustomMarkerView(frame: CGRect(x: 0, y: 0, width: customMarkerWidth, height: customMarkerHeight), image: stadiumData[i].img, borderColor: UIColor.darkGray, tag: i)
            marker.iconView=customMarker
        
            // 좌표
            marker.position = CLLocationCoordinate2D(latitude: latutude, longitude: longitude)
            marker.map = self.myMapView
        }
    }
    
    @objc func btnMyLocationAction() {
        let location: CLLocation? = myMapView.myLocation
        if location != nil {
            myMapView.animate(toLocation: (location?.coordinate)!)
        }
    }
    
    
    @objc func restaurantTapped(tag: Int) {
        let loginVC = self.storyboard?.instantiateViewController(identifier: "DetailStadiumViewController") as! DetailStadiumViewController
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    func setupTextField(textField: UITextField, img: UIImage){
        textField.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        imageView.image = img
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        paddingView.addSubview(imageView)
        textField.leftView = paddingView
    }
    
    func setupViews() {
        view.addSubview(myMapView)
        myMapView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myMapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myMapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myMapView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 60).isActive=true
        
        self.view.addSubview(txtFieldSearch)
        txtFieldSearch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive=true
        txtFieldSearch.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive=true
        txtFieldSearch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive=true
        txtFieldSearch.heightAnchor.constraint(equalToConstant: 60).isActive=true
        setupTextField(textField: txtFieldSearch, img: #imageLiteral(resourceName: "map_Pin"))
        
        // 마커 뷰 사이즈
        stadiumPreviewView=StadiumPreviewView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width - self.view.frame.width/4, height: 190))

        
        
        self.view.addSubview(btnMyLocation)
        btnMyLocation.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive=true
        btnMyLocation.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive=true
        btnMyLocation.widthAnchor.constraint(equalToConstant: 50).isActive=true
        btnMyLocation.heightAnchor.constraint(equalTo: btnMyLocation.widthAnchor).isActive=true
    }
    
    let myMapView: GMSMapView = {
        let v=GMSMapView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let txtFieldSearch: UITextField = {
        let tf=UITextField()
        tf.borderStyle = .roundedRect
        tf.backgroundColor = .white
        tf.layer.borderWidth = 1.0
        tf.layer.borderColor =  #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOffset = CGSize(width: 1 , height: 1)
        tf.layer.shadowOpacity = 0.5
        tf.layer.shadowRadius = 4.0
        tf.placeholder="지역을 검색해주세요."
        tf.translatesAutoresizingMaskIntoConstraints=false
        return tf
    }()
    
    let btnMyLocation: UIButton = {
        let btn=UIButton()
        btn.backgroundColor = UIColor.white
        btn.setImage(#imageLiteral(resourceName: "my_location"), for: .normal)
        btn.layer.cornerRadius = 25
        btn.clipsToBounds=true
        btn.tintColor = UIColor.gray
        btn.imageView?.tintColor=UIColor.gray
        btn.addTarget(self, action: #selector(btnMyLocationAction), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints=false
        return btn
    }()
    
    var stadiumPreviewView: StadiumPreviewView = {
        let v=StadiumPreviewView()
       
        return v
    }()
}




