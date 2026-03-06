import SwiftUI

struct ThemePickerView: View {
    @Binding var selectedTheme: AppTheme
    @Binding var isPresented: Bool

    var body: some View {
        VStack(spacing: 16) {
            Text("Theme")
                .font(.system(.headline, design: selectedTheme.fontDesign))
                .foregroundStyle(selectedTheme.textColor)

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 90))], spacing: 14) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    Button {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            selectedTheme = theme
                            isPresented = false
                        }
                    } label: {
                        VStack(spacing: 6) {
                            ZStack {
                                // Mini background
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(
                                        LinearGradient(
                                            colors: theme.backgroundGradientColors,
                                            startPoint: .top,
                                            endPoint: .bottom
                                        )
                                    )
                                    .frame(width: 56, height: 72)

                                // Mini card
                                RoundedRectangle(cornerRadius: theme.cardCornerRadius * 0.4)
                                    .fill(theme.cardBackgroundColor)
                                    .frame(width: 34, height: 44)

                                // Emoji
                                Text(theme.themeEmoji)
                                    .font(.system(size: 14))
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(selectedTheme == theme ? theme.accentColor : .clear, lineWidth: 3)
                            )

                            Text(theme.name)
                                .font(.system(size: 10, design: theme.fontDesign))
                                .foregroundStyle(selectedTheme.textColor)
                                .lineLimit(1)
                        }
                    }
                }
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(selectedTheme.cardBackgroundColor.opacity(0.95))
                .shadow(color: .black.opacity(0.3), radius: 20)
        )
        .padding(.horizontal, 24)
    }
}
