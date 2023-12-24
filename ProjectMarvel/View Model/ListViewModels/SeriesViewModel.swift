// -------------------------------------------------------------------------
// This item is the property of ResMed Ltd, and contains confidential and trade
// secret information. It may not be transferred from the custody or control of
// ResMed except as authorized in writing by an officer of ResMed. Neither this
// item nor the information it contains may be used, transferred, reproduced,
// published, or disclosed, in whole or in part, and directly or indirectly,
// except as expressly authorized by an officer of ResMed, pursuant to written
// agreement.
//
// Copyright (c) 2022 ResMed Ltd.  All rights reserved.
// -------------------------------------------------------------------------

import SwiftUI

class SeriesViewModel: ObservableObject {
    @Published var seriesList: [SeriesList] = []
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
                    decoder.decode(DetailCardModel4.self, from: data)
                    DispatchQueue.main.async {
                        self.seriesList.append(contentsOf: decodedResponse.data.results)
                        self.currentOffset = self.seriesList.count
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
    
    func shouldLoadMoreContent(currentSeries: SeriesList) -> Bool {
        guard seriesList.count != remoteTotal else { return false } // We've already fetched everything
        let endOffset = Int(-1.0 * Double(seriesList.endIndex) * 0.25)
        let thresholdIndex = seriesList.index(seriesList.endIndex, offsetBy: endOffset)
        return seriesList.firstIndex(where: { $0.id == currentSeries.id }) == thresholdIndex
    }
    
}
