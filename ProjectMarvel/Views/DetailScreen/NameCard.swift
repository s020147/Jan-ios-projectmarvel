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

struct NameCard: View {
    let character: CharacterResult
    
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .strokeBorder(.black, lineWidth: 1)
                .background(RoundedRectangle(cornerRadius: 25).fill(.white))
                .frame(width: geometry.size.width, height: geometry.size.width * 0.3)
                .overlay(
                    VStack(alignment: .leading) {
                        Text("Name")
                            .fontWeight(.medium)
                            .font(.system(size: 16))
                        Text("\(character.name)").fontWeight(.semibold)
                            .font(.system(size: 24))
                            .foregroundColor(Color.init( red: 66/255, green: 66/255, blue: 67/255))
                    }
                )
        }
    }
}

struct NameCard_Previews: PreviewProvider {
    static var previews: some View {
        NameCard(character: sampleCharacter)
    }
}
