//
//  ViewController.swift
//  TravelBook
//
//  Created by Burak Kaymak on 26.08.2025.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class ViewController: UIViewController, MKMapViewDelegate,CLLocationManagerDelegate{
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commentText: UITextField!
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var chosenTitle = ""
    var chosentitleID : UUID?
    
    var annotiationTitle = ""
    var annotiationSubtitle = ""
    var annotiationLatitude = Double()
    var annotiationLongitude = Double()
    
    var isPinned = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.save, target: self, action: #selector(saveButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //keskinlik payının en iyi olmasını söylüyorum.
        // locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // Birkaç kilometre yanılma payı olabilir.Pilden tasarrued edebilirim.
        //Ancak projem buna müsade edebilecek bir proje değil o yüzden en iyisini seçiyorum.
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let hideRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideRecognizer)
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(pinLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2.5
        mapView.addGestureRecognizer(gestureRecognizer)
        
        if chosenTitle != "" 
        {
            self.navigationItem.rightBarButtonItem?.isHidden = true
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
            let idString = chosentitleID!.uuidString
            fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                    
                    for result in results as! [NSManagedObject] {
                        
                        if let title = result.value(forKey: "title") as? String
                        {
                            annotiationTitle = title
                            if let subtitle = result.value(forKey:"subtitle") as? String
                            {
                                annotiationSubtitle = subtitle
                                if let latitude = result.value(forKey: "latitude") as? Double
                                {
                                    annotiationLatitude = latitude
                                    if let longitude = result.value(forKey: "longitude") as? Double 
                                    {
                                        annotiationLongitude = longitude
                                        
                                        let annotiation = MKPointAnnotation()
                                        annotiation.title = annotiationTitle
                                        annotiation.subtitle = annotiationSubtitle
                                        let coordinate = CLLocationCoordinate2D(latitude: annotiationLatitude, longitude: annotiationLongitude)
                                        annotiation.coordinate = coordinate
                                        
                                        mapView.addAnnotation(annotiation)
                                        nameText.text = annotiationTitle
                                        commentText.text = annotiationSubtitle
                                        
                                        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // ne kadar zoomlanacağını söyler.
                                        let region = MKCoordinateRegion(center: coordinate, span: span)
                                        mapView.setRegion(region, animated: true)
                                        
                                        
                                    }

                                }
                                
                            }
                            
                           
                        }
                        
                       
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                    
                    
                    
                }
                    
                    
                    
                    
                
                
            } catch {
                
            }
            
            
            
            
            
        } else
        {
           
            
            
            
        }
        
       
    }
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if chosenTitle == "" {
            let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // ne kadar zoomlanacağını söyler.
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        
        
    }
    
    @objc func pinLocation(gestureRecognizer : UILongPressGestureRecognizer){
        
        if gestureRecognizer.state == .began {
            
            let touchedPoint = gestureRecognizer.location(in: self.mapView)
            let touchedCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            chosenLatitude = touchedCoordinates.latitude
            chosenLongitude = touchedCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = nameText.text
            annotation.subtitle = commentText.text
            self.mapView.addAnnotation(annotation)
            isPinned = true
        }
        
        
    }
    
    @objc func hideKeyboard(){
        
        view.endEditing(true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation 
        {
            return nil
        }
        
        let reuseID = "myAnnotation"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil
        {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true // ekstra bilgi gösterebileceğim bilgi kutucuğu.
            pinView?.tintColor = UIColor.black
            
            let button = UIButton(type: UIButton.ButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        }
        
        else 
        {
            pinView?.annotation = annotation
        }
        
        return pinView
        
    }
    
    @objc func saveButtonClicked(){
        
        if nameText.text == "" {
            
            let alert = UIAlertController(title: "Warning", message: "Enter name first", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            alert.addAction(okButton)
            self.present(alert, animated: true)
            
        }
        
        if isPinned == false {
            let alert = UIAlertController(title: "Warning", message: "Enter a pin", preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            alert.addAction(okButton)
            self.present(alert,animated: true)
        }
        
        else 
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context)
            
            newPlace.setValue(nameText.text, forKey: "title")
            newPlace.setValue(commentText.text, forKey: "subtitle")
            newPlace.setValue(chosenLatitude, forKey: "latitude")
            newPlace.setValue(chosenLongitude, forKey: "longitude")
            newPlace.setValue(UUID(), forKey: "id")
            
            do{
                try context.save()
            }
            catch{
                
            }
            
            NotificationCenter.default.post(name: NSNotification.Name("newPlace"), object: nil)
            navigationController?.popViewController(animated: true)
            
        }
        
        
        
        
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if chosenTitle != "" {
            
            let requestLocation = CLLocation(latitude: annotiationLatitude, longitude: annotiationLongitude)
            
            CLGeocoder().reverseGeocodeLocation(requestLocation) { placemarks, error in
                
                if let placemark = placemarks {
                    
                    if placemark.count > 0 {
                        
                        let newPlacemark = MKPlacemark(placemark: placemark[0])
                        let item = MKMapItem(placemark: newPlacemark)
                        item.name = self.annotiationTitle
                        let launchOptions = [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving]
                        item.openInMaps(launchOptions: launchOptions)
                        
                        
                    }
                }
                
                
            }
            
            
            
            
        }
    }


}

