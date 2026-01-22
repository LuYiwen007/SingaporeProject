//
//  AppTheme.swift
//  Team Proj
//
//  Created by benny on 2026/1/22.
//

import SwiftUI

struct AppTheme {
    // MARK: - Colors
    struct Colors {
        // Primary Colors
        static let primaryBlue = Color(red: 0.2, green: 0.4, blue: 0.8)
        static let primaryPurple = Color(red: 0.5, green: 0.3, blue: 0.7)
        static let accentOrange = Color(red: 1.0, green: 0.6, blue: 0.2)
        
        // Background Colors
        static let background = Color(UIColor.systemBackground)
        static let secondaryBackground = Color(UIColor.secondarySystemBackground)
        static let cardBackground = Color(UIColor.systemBackground)
        
        // Text Colors
        static let primaryText = Color.primary
        static let secondaryText = Color.secondary
        static let tertiaryText = Color(UIColor.tertiaryLabel)
        
        // Message Bubble Colors
        static let userMessageBackground = Color(red: 0.2, green: 0.4, blue: 0.8)
        static let userMessageText = Color.white
        static let aiMessageBackground = Color(UIColor.secondarySystemBackground)
        static let aiMessageText = Color.primary
        
        // Category Colors
        static let verbColor = Color.blue
        static let nounColor = Color.green
        static let adjectiveColor = Color.purple
        static let adverbColor = Color.orange
        static let phraseColor = Color.pink
        
        // Status Colors
        static let correctGreen = Color.green
        static let incorrectRed = Color.red
        static let warningYellow = Color.yellow
        
        // UI Elements
        static let cardShadow = Color.black.opacity(0.1)
        static let divider = Color(UIColor.separator)
    }
    
    // MARK: - Fonts
    struct Fonts {
        static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
        static let title1 = Font.system(size: 28, weight: .bold, design: .rounded)
        static let title2 = Font.system(size: 22, weight: .bold, design: .rounded)
        static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
        static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
        static let body = Font.system(size: 17, weight: .regular, design: .default)
        static let callout = Font.system(size: 16, weight: .regular, design: .default)
        static let subheadline = Font.system(size: 15, weight: .regular, design: .default)
        static let footnote = Font.system(size: 13, weight: .regular, design: .default)
        static let caption = Font.system(size: 12, weight: .regular, design: .default)
        static let caption2 = Font.system(size: 11, weight: .regular, design: .default)
        
        // Custom Fonts
        static let wordTitle = Font.system(size: 24, weight: .bold, design: .rounded)
        static let definition = Font.system(size: 16, weight: .regular, design: .default)
        static let categoryBadge = Font.system(size: 12, weight: .semibold, design: .rounded)
    }
    
    // MARK: - Spacing
    struct Spacing {
        static let tiny: CGFloat = 4
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let extraLarge: CGFloat = 32
        static let huge: CGFloat = 48
    }
    
    // MARK: - Corner Radius
    struct CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 12
        static let large: CGFloat = 16
        static let extraLarge: CGFloat = 20
        static let round: CGFloat = 1000
    }
    
    // MARK: - Shadow
    struct Shadow {
        static let small: CGFloat = 2
        static let medium: CGFloat = 4
        static let large: CGFloat = 8
    }
    
    // MARK: - Animation
    struct Animation {
        static let quick = SwiftUI.Animation.easeInOut(duration: 0.2)
        static let standard = SwiftUI.Animation.easeInOut(duration: 0.3)
        static let slow = SwiftUI.Animation.easeInOut(duration: 0.5)
        static let spring = SwiftUI.Animation.spring(response: 0.3, dampingFraction: 0.7)
    }
}

// MARK: - View Extensions for Easy Styling
extension View {
    func cardStyle() -> some View {
        self
            .background(AppTheme.Colors.cardBackground)
            .cornerRadius(AppTheme.CornerRadius.medium)
            .shadow(color: AppTheme.Colors.cardShadow, radius: AppTheme.Shadow.medium, x: 0, y: 2)
    }
    
    func primaryButtonStyle() -> some View {
        self
            .padding()
            .background(AppTheme.Colors.primaryBlue)
            .foregroundColor(.white)
            .cornerRadius(AppTheme.CornerRadius.medium)
    }
    
    func categoryBadgeStyle(for category: WordCategory) -> some View {
        self
            .font(AppTheme.Fonts.categoryBadge)
            .padding(.horizontal, AppTheme.Spacing.small)
            .padding(.vertical, AppTheme.Spacing.tiny)
            .background(categoryColor(for: category).opacity(0.2))
            .foregroundColor(categoryColor(for: category))
            .cornerRadius(AppTheme.CornerRadius.small)
    }
    
    private func categoryColor(for category: WordCategory) -> Color {
        switch category {
        case .verb: return AppTheme.Colors.verbColor
        case .noun: return AppTheme.Colors.nounColor
        case .adjective: return AppTheme.Colors.adjectiveColor
        case .adverb: return AppTheme.Colors.adverbColor
        case .phrase: return AppTheme.Colors.phraseColor
        }
    }
}
