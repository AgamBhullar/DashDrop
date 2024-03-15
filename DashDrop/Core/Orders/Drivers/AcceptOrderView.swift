//
//  AcceptOrderView.swift
//  DashDrop
//
//  Created by Agam Bhullar on 3/6/24.
//

import SwiftUI
import MapKit

struct AcceptOrderView: View {
    private let user: User
    @State private var region: MKCoordinateRegion
    let order: Order
    let annotationItem: DashDropLocation
    @EnvironmentObject var viewModel: HomeViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(order: Order, user: User) {
        let center = CLLocationCoordinate2D(latitude: order.pickupLocation.latitude,
                                            longitude: order.pickupLocation.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.025,
                                    longitudeDelta: 0.025)
        self.region = MKCoordinateRegion(center: center, span: span)
        self.order = order
        self.annotationItem = DashDropLocation(title: order.pickupLocationName, coordinate: order.customerLocation.toCoordinate())
        
        self.user = user
    }
    
    var body: some View {
        if let user = viewModel.currentUser {
            VStack{
                Capsule()
                    .foregroundColor(Color(.systemGray5))
                    .frame(width: 48, height: 6)
                    .padding(.top, 8)
                
                // would you like to pickup view
                VStack {
                    HStack {
                        Text("Would you like to pickup this package?")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(height: 44)
                       
                        Spacer()
                        
                        VStack {
                            Text("\(order.travelTimeToCustomer)")
                                .bold()
                            
                            Text("min")
                                .bold()
                        }
                        .frame(width: 56, height: 56)
                        .foregroundColor(.white)
                        .background(Color(.systemBlue))
                        .cornerRadius(8)
                    }
                    .padding()
                    
                    Divider()
                }
                
                // user info view
                VStack {
                    HStack {
//                        Text(user.initials)
//                            .font(.title)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//                            .frame(width: 72, height: 72)
//                            .background(Color(.systemGray3))
//                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Customer:")
                                .fontWeight(.bold)
                            Text(order.customerName)

                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(Color(.systemYellow))
                                    .imageScale(.small)
                                
                                Text("4.8")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(spacing: 6) {
                            Text("Earnings")
                            
                            Text(order.tripCost.toCurrency())
                                .font(.system(size: 24, weight: .semibold))
                        }
                        
                    }
                    
                    Divider()
                }
                .padding()
                
                // pickup location info view
                VStack {
                    //order location info
                    HStack {
                        //address info
                        VStack(alignment: .leading, spacing: 6) {
                            Text(order.pickupLocationName)
                                .font(.headline)
                            
                            Text(order.pickupLocationAddress)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        //distance
                        VStack {
                            Text(order.distanceToCustomer.distanceInMilesString())
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            Text("mi")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal)
                    
                    //map
                    Map(coordinateRegion: $region, annotationItems: [annotationItem]) { item in
                        MapMarker(coordinate: item.coordinate)
                    }
                    .frame(height: 220)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.6), radius: 10)
                    .padding()
                    
                    //divider
                    
                    Divider()
                }
                
                // action buttons
                HStack {
                    Button {
                        viewModel.rejectOrder()
                        if let orderId = order.orderId {
                                viewModel.markOrderAsRejectedForDriver(orderId: orderId)
                                viewModel.resetDriverState()
                            }
                            self.presentationMode.wrappedValue.dismiss()
                        
                    } label: {
                        Text("Reject")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width / 2) - 32,
                                   height: 56)
                            .background(Color(.systemRed))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button {
                        viewModel.acceptOrder()
                    } label: {
                        Text("Accept")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: (UIScreen.main.bounds.width / 2) - 32,
                                   height: 56)
                            .background(Color(.systemBlue))
                            .cornerRadius(10)
                            .foregroundColor(.white)
                    }

                }
                .padding(.top)
                .padding(.horizontal)
                .padding(.bottom, 24)
            }
            .background(Color.theme.backgroundColor)
            .cornerRadius(16)
            .shadow(color: Color.theme.secondaryBackgroundColor, radius: 20)
        }
    }
}


struct AcceptOrderView_Previews: PreviewProvider {
    static var previews: some View {
        AcceptOrderView(order: dev.mockOrder, user: dev.mockUser)
    }
}


