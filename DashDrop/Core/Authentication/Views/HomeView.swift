
import SwiftUI

struct HomeView: View {
    
    //@State private var mapState = MapViewState.noneInput
    @EnvironmentObject var authViewModel: AuthViewModel
    var body: some View {
//        if authViewModel.userSession == nil{
//            LoginView()
//        } else {
//            Text("Hello")
////            MapViewRepresentable()
////                .ignoresSafeArea()
//        }
        
        MapViewRepresentable()
            .ignoresSafeArea()
    }
}

#Preview {
    HomeView()
}

//import SwiftUI
//
//struct HomeView: View {
//    @State private var mapState = MapViewState.noInput
//    
//    var body: some View {
//        ZStack(alignment: .top) {
//            MapViewRepresentable(mapState: $mapState)
//                .ignoresSafeArea()
//            
//            if mapState == .searchingForLocation {
//                LocationSearchView(mapState: $mapState)
//            } else if mapState == .noInput {
//                LocationSearchActivationView()
//                    .padding(.top, 72)
//                    .onTapGesture {
//                        withAnimation(.spring()) {
//                            mapState = .searchingForLocation
//                        }
//                    }
//            }
//            
//            MapViewActionButton(mapState: $mapState)
//                .padding(.leading)
//                .padding(.top, 4)
//        }
//        
//    }
//}
//
//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
