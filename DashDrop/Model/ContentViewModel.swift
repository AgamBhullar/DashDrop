
import Foundation
import MapKit
import Combine

class ContentViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var searchQuery = ""
    @Published var suggestions: [MKLocalSearchCompletion] = []

    private var searchCompleter = MKLocalSearchCompleter()
    private var cancellables: Set<AnyCancellable> = []

    override init() {
        super.init()
        searchCompleter.delegate = self

        // Setup Combine to listen to searchQuery changes
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] (query) in
                self?.searchCompleter.queryFragment = query
            }
            .store(in: &cancellables)
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Update your UI with the suggestions
        DispatchQueue.main.async {
            self.suggestions = completer.results
        }
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
