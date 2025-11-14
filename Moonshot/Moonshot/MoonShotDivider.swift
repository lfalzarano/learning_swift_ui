//
//  MoonShotDivider.swift
//  Moonshot
//
//  Created by Logan Falzarano on 11/13/25.
//

import SwiftUI

struct MoonShotDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 2)
            .foregroundStyle(.lightBackground)
            .padding(.vertical)
    }
}

#Preview {
    MoonShotDivider()
        .preferredColorScheme(.dark)
}
