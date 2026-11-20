
import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct MediaClip: Identifiable {
    let id = UUID()
    let data: Data
    let isVideo: Bool
    var image: UIImage? { isVideo ? nil : UIImage(data: data) }
}

struct EditTemplate: Identifiable {
    let id = UUID()
    let name: String
    let subtitle: String
    let symbol: String
    let colors: [Color]
}

struct ContentView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var clips: [MediaClip] = []
    @State private var selectedTemplate = "Velocity"
    @State private var showEditor = false
    @State private var isImporting = false

    private let templates = [
        EditTemplate(name: "Velocity", subtitle: "Fast transitions", symbol: "bolt.fill", colors: [.purple, .blue]),
        EditTemplate(name: "Cinematic", subtitle: "Movie style", symbol: "film.fill", colors: [.orange, .red]),
        EditTemplate(name: "Vlog", subtitle: "Clean and simple", symbol: "video.fill", colors: [.pink, .purple]),
        EditTemplate(name: "Flash", subtitle: "Beat sync style", symbol: "sparkles", colors: [.blue, .cyan])
    ]

    var body: some View {
        ZStack {
            Color(red: 0.035, green: 0.035, blue: 0.06).ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    header

                    VStack(alignment: .leading, spacing: 8) {
                        Text("CREATE SOMETHING")
                            .font(.system(size: 12, weight: .bold))
                            .tracking(2)
                            .foregroundStyle(.gray)

                        Text("Your next edit\nstarts here.")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundStyle(.white)
                    }

                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 20,
                        matching: .any(of: [.images, .videos])
                    ) {
                        HStack(spacing: 15) {
                            Image(systemName: "plus")
                                .font(.title2.bold())
                                .frame(width: 48, height: 48)
                                .background(.white.opacity(0.15))
                                .clipShape(RoundedRectangle(cornerRadius: 15))

                            VStack(alignment: .leading, spacing: 4) {
                                Text("New project")
                                    .font(.headline)
                                Text("Import photos and videos")
                                    .font(.caption)
                                    .foregroundStyle(.white.opacity(0.65))
                            }

                            Spacer()
                            Image(systemName: "arrow.up.right")
                        }
                        .foregroundStyle(.white)
                        .padding(18)
                        .background(
                            LinearGradient(colors: [.purple, .blue], startPoint: .leading, endPoint: .trailing)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 22))
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        sectionTitle("Templates", detail: "Explore styles")

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 13) {
                                ForEach(templates) { template in
                                    Button {
                                        withAnimation(.spring(response: 0.35)) {
                                            selectedTemplate = template.name
                                        }
                                    } label: {
                                        VStack(alignment: .leading, spacing: 12) {
                                            Image(systemName: template.symbol)
                                                .font(.system(size: 30))
                                                .frame(maxWidth: .infinity, minHeight: 95)
                                                .background(
                                                    LinearGradient(colors: template.colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                                                )
                                                .clipShape(RoundedRectangle(cornerRadius: 15))

                                            Text(template.name)
                                                .font(.headline)
                                                .foregroundStyle(.white)

                                            Text(template.subtitle)
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                        }
                                        .padding(10)
                                        .frame(width: 145)
                                        .background(selectedTemplate == template.name ? Color.purple.opacity(0.25) : Color.white.opacity(0.05))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 18)
                                                .stroke(selectedTemplate == template.name ? Color.purple : Color.white.opacity(0.08), lineWidth: 1)
                                        }
                                        .clipShape(RoundedRectangle(cornerRadius: 18))
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        sectionTitle("Auto Edit", detail: "One tap")

                        Button {
                            withAnimation(.spring()) {
                                showEditor = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "wand.and.stars")
                                    .font(.title)
                                    .foregroundStyle(.purple)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Create automatic edit")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text("Arrange your imported clips with a selected style")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.gray)
                            }
                            .padding(18)
                            .background(Color.white.opacity(0.06))
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .buttonStyle(.plain)
                        .disabled(clips.isEmpty)
                        .opacity(clips.isEmpty ? 0.5 : 1)
                    }

                    VStack(alignment: .leading, spacing: 14) {
                        sectionTitle("Your media", detail: "\(clips.count) clips")

                        if clips.isEmpty {
                            Text("Your imported photos and videos will appear here")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                                .frame(maxWidth: .infinity)
                                .padding(28)
                                .background(Color.white.opacity(0.04))
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        } else {
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(clips) { clip in
                                    ZStack {
                                        if let image = clip.image {
                                            Image(uiImage: image)
                                                .resizable()
                                                .scaledToFill()
                                        } else {
                                            Color.purple.opacity(0.25)
                                            Image(systemName: "play.rectangle.fill")
                                                .font(.largeTitle)
                                                .foregroundStyle(.white)
                                        }
                                    }
                                    .frame(height: 105)
                                    .frame(maxWidth: .infinity)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }
                }
                .padding(20)
            }
        }
        .preferredColorScheme(.dark)
        .onChange(of: selectedItems) { newItems in
            Task {
                isImporting = true
                var imported: [MediaClip] = []
                for item in newItems {
                    let isVideo = item.supportedContentTypes.contains { $0.conforms(to: .movie) }
                    if let data = try? await item.loadTransferable(type: Data.self) {
                        imported.append(MediaClip(data: data, isVideo: isVideo))
                    }
                }
                await MainActor.run {
                    clips.append(contentsOf: imported)
                    selectedItems = []
                    isImporting = false
                }
            }
        }
        .sheet(isPresented: $showEditor) {
            editorView
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "aperture")
                    .font(.title2)
                    .foregroundStyle(.purple)
                Text("NOVA")
                    .font(.title2.bold())
                    .tracking(2)
                    .foregroundStyle(.white)
            }
            Spacer()
            Image(systemName: "slider.horizontal.3")
                .font(.title3)
                .foregroundStyle(.white)
        }
    }

    private func sectionTitle(_ title: String, detail: String) -> some View {
        HStack {
            Text(title)
                .font(.title3.bold())
                .foregroundStyle(.white)
            Spacer()
            Text(detail)
                .font(.caption)
                .foregroundStyle(.gray)
        }
    }

    private var editorView: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.035, green: 0.035, blue: 0.06).ignoresSafeArea()
                VStack(spacing: 20) {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 45))
                        .foregroundStyle(.purple)

                    Text("Your \(selectedTemplate) edit")
                        .font(.title.bold())
                        .foregroundStyle(.white)

                    Text("\(clips.count) clips ready")
                        .foregroundStyle(.gray)

                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(clips) { clip in
                                if let image = clip.image {
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 130)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                } else {
                                    Image(systemName: "play.rectangle.fill")
                                        .font(.largeTitle)
                                        .frame(width: 100, height: 130)
                                        .background(.purple.opacity(0.25))
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                }
                            }
                        }
                    }

                    Text("Auto edit preview")
                        .font(.headline)
                        .foregroundStyle(.white)

                    Text("This is a preview of your selected clips and template. Video effects and export are not implemented yet.")
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.gray)

                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { showEditor = false }
                        .foregroundStyle(.purple)
                }
            }
        }
    }
}
