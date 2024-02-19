//
//  MapViewModel.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

//import Foundation
//import MapKit
//
//class MapViewModel: ObservableObject {
//
//    @Published var region = MKCoordinateRegion()
//    @Published var annotationItems: [AnnotationItem] = []
//    
//    
//    func getPlace(from address: AddressResult) {
//        let request = MKLocalSearch.Request()
//        let title = address.title
//        let subTitle = address.subtitle
//        
//        request.naturalLanguageQuery = subTitle.contains(title)
//        ? subTitle : title + ", " + subTitle
//        
//        Task {
//            let response = try await MKLocalSearch(request: request).start()
//            await MainActor.run {
//                self.annotationItems = response.mapItems.map {
//                    AnnotationItem(
//                        latitude: $0.placemark.coordinate.latitude,
//                        longitude: $0.placemark.coordinate.longitude
//                    )
//                }
//                
//                self.region = response.boundingRegion
//            }
//        }
//    }
//}

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    
    @Published var region = MKCoordinateRegion()
    @Published var annotationItems: [AnnotationItem] = []
    
    func getPlace(from address: AddressResult) {
        let request = MKLocalSearch.Request()
        let title = address.title
        let subTitle = address.subtitle
        
        request.naturalLanguageQuery = subTitle.contains(title)
        ? subTitle : title + ", " + subTitle
        
        Task {
            let response = try await MKLocalSearch(request: request).start()
            await MainActor.run {
                self.annotationItems = response.mapItems.map {
                    AnnotationItem(
                        latitude: $0.placemark.coordinate.latitude,
                        longitude: $0.placemark.coordinate.longitude
                    )
                }
                
                self.region = response.boundingRegion
            }
        }
    }
    
    // New function to get full address including city, state, and zip code
    func getFullAddress(from address: AddressResult, completion: @escaping (String) -> Void) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = address.title + ", " + address.subtitle
        
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion("Address not found")
                return
            }
            
            if let firstItem = response.mapItems.first {
                let placemark = firstItem.placemark
                let street = placemark.thoroughfare ?? ""
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                let fullAddress = "\(street), \(city), \(state) \(postalCode)"
                completion(fullAddress)
            } else {
                completion("Address not found")
            }
        }
    }
}
