//
//  RoundedCorners.swift
//  atprosphere
//
//  Created by Thomas Rademaker on 10/30/23.
//

import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorners(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorners(radius: radius, corners: corners) )
    }
}

#Preview {
    Rectangle()
        .fill(Color.blue)
        .roundedCorners(20, corners: [.topLeft, .topRight])
}
