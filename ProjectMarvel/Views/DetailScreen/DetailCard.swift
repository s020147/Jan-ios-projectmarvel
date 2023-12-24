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

struct DetailCard: View {
    // MARK: - Properties
    var title: String
    var value: Int
    var linkTitle: String
    var link: URL? = nil
    let destination: String?
    
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.init(red: 255, green: 255, blue: 255, opacity: 1)
            VStack {
                Text("\(value)")
                    .font(.system(size: 40))
                    .fontWeight(.semibold)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.gray)
                
                if (linkTitle == "stories") {
                    NavigationLink(destination: StoryView(destination: destination!)) {
                        Text("View \(linkTitle)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 173/255, green: 17/255, blue: 24/255, opacity: 1))
                    }
                    .padding(.horizontal)
                    .padding(.top, 1)
                    .padding(.bottom, 8)
                } else if (linkTitle == "comics") {
                    NavigationLink(destination: ComicView(destination: destination!)) {
                        Text("View \(linkTitle)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 173/255, green: 17/255, blue: 24/255, opacity: 1))
                    }
                    .padding(.horizontal)
                    .padding(.top, 1)
                    .padding(.bottom, 8)
                } else if (linkTitle == "events") {
                    NavigationLink(destination: EventView(destination: destination!)) {
                        Text("View \(linkTitle)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 173/255, green: 17/255, blue: 24/255, opacity: 1))
                    }
                    .padding(.horizontal)
                    .padding(.top, 1)
                    .padding(.bottom, 8)
                } else {
                    NavigationLink(destination: SeriesView(destination: destination!)) {
                        Text("View \(linkTitle)")
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: 173/255, green: 17/255, blue: 24/255, opacity: 1))
                    }
                    .padding(.horizontal)
                    .padding(.top, 1)
                    .padding(.bottom, 8)
                }
            }
        }
        .cornerRadius(8)
        .shadow(color: Color.gray.opacity(0.2), radius: 5)
    }
}

struct DetailCard_Previews: PreviewProvider {
    static var previews: some View {
        DetailCard(title: "Stories", value: 120, linkTitle: "stories", destination: "www.google.com")
    }
}
