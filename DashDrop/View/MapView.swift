import SwiftUI
import MapKit

struct MapView: View {
    @ObservedObject var orderDetails: OrderDetails
    @StateObject private var viewModel = MapViewModel()
    @State private var navigateToStoreSelection = false // Used to activate NavigationLink programmatically
    
    private let address: AddressResult
    
    init(address: AddressResult, orderDetails: OrderDetails) {
        self.address = address
        self._orderDetails = ObservedObject(initialValue: orderDetails) // Correct way to initialize
    }
    
    var body: some View {
        //NavigationView { // Ensure NavigationView wraps your content
            ZStack {
                Map(coordinateRegion: $viewModel.region, annotationItems: viewModel.annotationItems, annotationContent: { item in
                    MapMarker(coordinate: item.coordinate)
                })
                VStack {
                    Spacer()
                    NavigationLink(destination: StoreSelectionView(orderDetails: orderDetails), isActive: $navigateToStoreSelection) { EmptyView() }
                    Button("Select Store") {
                        navigateToStoreSelection = true // This triggers the navigation
                    }
                    .padding(.bottom, 20)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .shadow(radius: 3)
                }
            }
            .onAppear {
                self.viewModel.getPlace(from: address)
                self.orderDetails.address = address
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarTitle("Map", displayMode: .inline) // Optionally set a navigation bar title
        //}
    }
}
