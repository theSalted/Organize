import SwiftUI

struct OnboardTipView: View {
    @Environment(OnboardViewModel.self) private var onboardViewModel
    @Environment(AppViewModel.self) private var appViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            VStack {
                Text(
                    "Tips to")
                .font(.system(.headline, design: .rounded))
                .lineSpacing(10)
                .multilineTextAlignment(.center)
                Text("Get Started")
                    .font(.system(.largeTitle, weight: .bold))
                    .multilineTextAlignment(.center)
            }.padding([.top, .horizontal], 50)
            Divider().padding(.horizontal, 50)
            GroupBox {
                HStack(spacing: 20) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 50, weight: .regular, design: .default))
                    VStack(alignment: .leading) {
                        Text("Get Help").font(.headline)
                        Text("To return to this page, simply tap help button (question mark) on the sidebar.")
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 50)
            
            GroupBox {
                HStack(spacing: 20) {
                    Image(systemName: "square.split.bottomrightquarter")
                        .font(.system(size: 50, weight: .regular, design: .default))
                    VStack(alignment: .leading) {
                        Text("Scan Your Surrounding").font(.headline)
                        Text("When you hit the 'continue' button, you will be taking to the scan tab to scan your surrounding room")
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 50)
            GroupBox {
                HStack(spacing: 20) {
                    Image(systemName: "cube")
                        .font(.system(size: 50, weight: .regular, design: .default))
                    VStack(alignment: .leading) {
                        Text("Capture Lots of Object").font(.headline)
                        Text("You will have option to capture objects around you to organize. The demo works better if you have many captures. Try to take pictures instead if you can't.")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 50)
            GroupBox {
                HStack(spacing: 20) {
                    Image(systemName: "thermometer.high")
                        .font(.system(size: 50, weight: .regular, design: .default))
                        .frame(width: 60)
                    VStack(alignment: .leading) {
                        Text("This Demo is Resource Intensive").font(.headline)
                        Text("Let your device cool before doing this demo. Make sure there are no other heavy processs that's running. If this demo creash, simly re-run. Your data should persist.")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }.padding(.horizontal, 50)
            Spacer()
            Button("Continue") {
                withAnimation {
                    onboardViewModel.showOnboarding = false
                }
                onboardViewModel.stage = .foreword
                appViewModel.tabViewSelection = .scan
            }
            .buttonStyle(GlowingButtonStyle())
            .padding()
            .padding(.bottom)
        }
    }
}
