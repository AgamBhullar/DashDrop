import SwiftUI
import MapKit

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var orderDetails = OrderDetails()
    @State private var navigateToStoreSelection = false

    var body: some View {
            VStack {
                TextField("Enter Pickup Address", text: $viewModel.searchQuery)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.black)
                
                // Optional: Set a fixed height for the List if needed to improve scrollability
                List(viewModel.suggestions, id: \.self) { suggestion in
                    Button(action: {
                        self.convertToFullAddress(searchCompletion: suggestion) { fullAddressString in
                            orderDetails.fullAddress = fullAddressString
                            self.navigateToStoreSelection = true
                        }
                    }) {
                        VStack(alignment: .leading) {
                            Text(suggestion.title)
                                .fontWeight(.bold)
                            Text(suggestion.subtitle)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(maxHeight: .infinity) // Adjust height as needed
                
                NavigationLink(destination: StoreSelectionView(orderDetails: orderDetails), isActive: $navigateToStoreSelection) {
                    EmptyView()
                }
                //self.navigateToStoreSelection = true
            }
//            .background {
//                Image("Background2")
//                    .overlay(Color("CustomColor1").opacity(0.4))
//            }
            .navigationTitle("Address Search")
            .gesture(
                DragGesture().onChanged { _ in
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            )
    }
    
    func convertToFullAddress(searchCompletion: MKLocalSearchCompletion, completion: @escaping (String) -> Void) {
        let searchRequest = MKLocalSearch.Request(completion: searchCompletion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { response, error in
            guard let response = response, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion("Address not found")
                return
            }
            
            if let firstItem = response.mapItems.first {
                let placemark = firstItem.placemark
                
                // Debug print statements to verify address parts
                print("subThoroughfare: \(placemark.subThoroughfare ?? "N/A")")
                print("Thoroughfare: \(placemark.thoroughfare ?? "N/A")")
                print("Locality: \(placemark.locality ?? "N/A")")
                print("Administrative Area: \(placemark.administrativeArea ?? "N/A")")
                print("Postal Code: \(placemark.postalCode ?? "N/A")")
                
                let streetNumber = placemark.subThoroughfare ?? ""
                let streetName = placemark.thoroughfare ?? ""
                let city = placemark.locality ?? ""
                let state = placemark.administrativeArea ?? ""
                let postalCode = placemark.postalCode ?? ""
                let fullAddress = "\(streetNumber) \(streetName), \(city), \(state) \(postalCode)"
                completion(fullAddress)
            } else {
                completion("Address not found")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ContentView()
        }
    }
}
