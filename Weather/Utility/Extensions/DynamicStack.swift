//
//  AdaptiveStack.swift
//  Weather
//
//  Created by Sharath on 11/10/24.
//

import SwiftUI

struct DynamicStack<Content: View>: View {
    @Environment(\.verticalSizeClass) private var verticalSizeClass: UserInterfaceSizeClass?
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass: UserInterfaceSizeClass?

    var horizontalAlignment = HorizontalAlignment.center
    var verticalAlignment = VerticalAlignment.center
    var spacing: CGFloat?
    var isVertical = true
    @ViewBuilder var content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            Group {
                
                if horizontalSizeClass == .compact && verticalSizeClass == .regular {
                    if isVertical {
                        VStack(
                            alignment: horizontalAlignment,
                            spacing: spacing,
                            content: content
                        )
                    } else {
                        HStack(
                            alignment: verticalAlignment,
                            spacing: spacing,
                            content: content
                        )
                    }
                } else {
                    if !isVertical {
                        VStack(
                            alignment: horizontalAlignment,
                            spacing: spacing,
                            content: content
                        )
                    } else {
                        HStack(
                            alignment: verticalAlignment,
                            spacing: spacing,
                            content: content
                        )
                    }
                }
            }
        }
    }
}
