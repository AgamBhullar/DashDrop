//
//  ContentViewModel.swift
//  DashDrop
//
//  Created by Agam Bhullar on 2/13/24.
//

import Foundation
import MapKit

class ContentViewModel: NSObject, ObservableObject {
    
    @Published private(set) var results: Array<AddressResult> = []
    @Published var searchableText = ""

    private lazy var localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        completer.delegate = self
        return completer
    }()
    
    func searchAddress(_ searchableText: String) {
        guard searchableText.isEmpty == false else { return }
        localSearchCompleter.queryFragment = searchableText
    }
}

extension ContentViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        Task {
            for completion in completer.results {
                let searchRequest = MKLocalSearch.Request(completion: completion)
                let search = MKLocalSearch(request: searchRequest)
                do {
                    let response = try await search.start()
                    if let item = response.mapItems.first {
                        let placemark = item.placemark
                        // Create your address string here
                        let subtitle = "\(placemark.thoroughfare ?? ""), \(placemark.locality ?? ""), \(placemark.administrativeArea ?? "") \(placemark.postalCode ?? "")"
                        let addressResult = AddressResult(title: completion.title, subtitle: subtitle)
                        
                        await MainActor.run {
                            self.results.append(addressResult)
                        }
                    }
                } catch {
                    print("Error searching for placemark: \(error)")
                }
            }
        }
    }

    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
}
