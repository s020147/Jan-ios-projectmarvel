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

struct CardGallery: View {
    let character: CharacterResult
    var spacingValue: CGFloat = 20
    var repeatedLink: String = "?ts=1&apikey=\(Environment.apiKey)\(Environment.hash)"
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Literature")
                .foregroundColor(Color.init(red: 66/255, green: 66/255, blue: 67/255))
                .fontWeight(.semibold)
                .padding(.leading, 16)
            
            
            HStack(alignment: .center, spacing: spacingValue) {
                VStack(alignment: .center, spacing: spacingValue) {
                    DetailCard(title: "Stories", value: character.stories.available, linkTitle: "stories", destination:  "\(character.stories.collectionURI)\(repeatedLink)")
                    DetailCard(title: "Events", value: character.events.available, linkTitle: "events", destination: "\(character.events.collectionURI)\(repeatedLink)")
                }
                VStack(alignment: .center, spacing: spacingValue) {
                    DetailCard(title: "Comics", value: character.comics.available, linkTitle: "comics", destination:  "\(character.comics.collectionURI)\(repeatedLink)")
                    DetailCard(title: "Series", value: character.series.available, linkTitle: "series", destination: "\(character.series.collectionURI)\(repeatedLink)")
                }
            }
            .padding()
        }
    }
}

struct CardGallery_Previews: PreviewProvider {
    static var previews: some View {
        CardGallery(character: sampleCharacter)
    }
}
