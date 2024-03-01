import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userModel: UserModel
    @EnvironmentObject var navigationController: NavigationController
    @EnvironmentObject var appData: AppData
    @State private var isButtonPressed = false
    @State private var showOrderTracking = false
    // Assume `orderDetails` will be provided or fetched appropriately in your actual app
//    @ObservedObject var orderDetails = OrderDetails()
    //@StateObject var orderDetails = OrderDetails() // Owns and initializes OrderDetails

    @EnvironmentObject var orderDetails: OrderDetails
    
    var body: some View {
        NavigationView {
            VStack {
                Image("Guy") // Assuming you've added a logo here
                        .resizable()
                        .scaledToFit()
                        .frame(width: 700, height: 200)
                        .padding(.top)
                Text("How to create an order")
                    //.font(.largeTitle)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .font(.system(size: 60))
                
                Rectangle()
                        .fill(Color.black)
                        .frame(height: 6)
                        .padding(.horizontal)

                VStack(alignment: .leading, spacing: 13) { // VStack for the list, aligned to the left
                    Text("• Enter an address for pickup")
                        .font(.system(size: 29))
                    Text("• Select Store")
                        .font(.system(size: 29))
                    Text("• Select a package type")
                        .font(.system(size: 29))
                    Text("• QR code or Pre-Paid label")
                        .font(.system(size: 29))
                }
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .cornerRadius(10)
                        .background(isButtonPressed ? Color.cyan.opacity(0.8) : Color.cyan)
                        .shadow(radius: 10)
                
                Rectangle()
                        .fill(Color.black)
                        .frame(height: 6)
                        .padding(.horizontal)
                
                
                // Your existing HomeView content
                Spacer()
                NavigationLink(destination: ContentView(), isActive: $navigationController.shouldShowHomeView) {
                    Text("Request Pickup")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(isButtonPressed ? Color("CustomColor1").opacity(0.8) : Color("CustomColor1"))
                        .cornerRadius(10)
                        .shadow(radius: 10)
                }
                // Animation for Button Press
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isButtonPressed = true }
                        .onEnded { _ in isButtonPressed = false }
                )
                .animation(.easeInOut(duration: 0.2), value: isButtonPressed)
                .padding()
            }
//            .background {
//                Image("Background2") // This sets an image as the background
//                    .overlay(Color("CustomColor1").opacity(0.4)) // This overlays a color on top of the image
//            }
            .navigationBarTitle("Home", displayMode: .inline)
            .navigationBarItems(
                leading: NavigationLink(destination: OrderInformationView(orderDetails: appData.lastOrderDetails ?? OrderDetails()), isActive: $showOrderTracking) {
                    Image(systemName: "doc.plaintext")
                        .foregroundColor(Color.cyan)
                },
                // If you still want to keep the Settings icon, you can place it in the trailing position
                trailing: NavigationLink(destination: SettingsView().environmentObject(userModel)) {
                    Image(systemName: "person")
                        .foregroundColor(Color.cyan)
                }
            )
        }

    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        // Create an instance of NavigationController
        let navigationController = NavigationController()
        
        // Provide both the UserModel and NavigationController as environment objects
        HomeView()
            .environmentObject(UserModel())
            .environmentObject(AppData())
            .environmentObject(navigationController)
    }
}
