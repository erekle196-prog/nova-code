import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 25) {
                Text("NOVA STUDIO")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)

                Text("Your creative editing space")
                    .foregroundColor(.gray)

                Button("＋ New Project") {}
                    .font(.headline)
                    .foregroundColor(.black)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.white)
                    .cornerRadius(15)

                Text("Your projects will appear here")
                    .foregroundColor(.gray)

                Spacer()
            }
            .padding()
            .padding(.top, 50)
        }
    }
}
