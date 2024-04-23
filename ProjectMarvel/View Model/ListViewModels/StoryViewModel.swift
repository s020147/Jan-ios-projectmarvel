//
//  Created by Dustin Tong on 2/14/24.
//


import SwiftUI

class StoryViewModel: ObservableObject {
    @Published var storyList: [StoryList] = []
    private var currentOffset = 0
    private var remoteLimit = 0
    private var remoteTotal = 0
    
    func loadData(urlString: String) {
        
        var fullyFormedURLString = urlString
        if currentOffset > 0 {
            fullyFormedURLString = "\(urlString)&offset=\(currentOffset)"
        }
        
        // Should throw an error here
        guard let url = URL(string: fullyFormedURLString) else { return }
        
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let decodedResponse = try
                    decoder.decode(DetailCardModel.self, from: data)
                    DispatchQueue.main.async {
                        self.storyList.append(contentsOf: decodedResponse.data.results)
                        self.currentOffset = self.storyList.count
                        self.remoteLimit = decodedResponse.data.limit
                        self.remoteTotal = decodedResponse.data.total
                    }
                    return
                } catch {
                    print(error)
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
    
    func shouldLoadMoreContent(currentStory: StoryList) -> Bool {
        guard storyList.count != remoteTotal else { return false } // We've already fetched everything
        let endOffset = Int(-1.0 * Double(storyList.endIndex) * 0.25)
        let thresholdIndex = storyList.index(storyList.endIndex, offsetBy: endOffset)
        return storyList.firstIndex(where: { $0.id == currentStory.id }) == thresholdIndex
    }
    
}
