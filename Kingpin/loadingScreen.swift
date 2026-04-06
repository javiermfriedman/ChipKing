import SwiftUI

struct loadingScreen: View {
    @StateObject var collector = SeriesCollector()
    @State var newGameName = ""
    @State var showHowTo = false
    @State var showTextField = false
    @State private var isLoading = true
    @State var showDeleteSheet = false
    @State var errorMessage: String? = nil  // State variable for error message

    var body: some View {
        NavigationView {
            ZStack {
                Image("cardsBackground")
                    .resizable()
                    .ignoresSafeArea()
                    .aspectRatio(contentMode: .fill)

                VStack(spacing: 10){
                    Text("AN APP BY JAVI")
                        .foregroundStyle(.gray)
                        .opacity(0.4)
                        .padding(.top, 0)
                    
                    Image("CHIPKING")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 350)
                        .opacity(0.95)
                    
                    Spacer()
                }

                if isLoading {
                    ProgressView("Loading Series...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(1.5)
                        .padding()
                } else {
                    VStack(spacing: 25) {
                        Spacer()
                        Spacer()
                        
                        if showTextField {
                            VStack(alignment: .leading) {
                                HStack {
                                    
                                    TextField("Tap To Make Title", text: $newGameName)
                                        .font(.title3)
                                        .foregroundStyle(.black)
                                        .onChange(of: newGameName, { _, _ in
                                            errorMessage = nil
                                        })
                                       
                                        .onSubmit {
                                            if newGameName != "" {
                                                // Check for duplicate series name
                                                if collector.arrayOfSeries.contains(where: { $0.name == newGameName }) {
                                                    errorMessage = "This Name Is Already in Use"
                                                } else {
                                                    let newGame = Series(input: newGameName)
                                                    collector.addSeries(game: newGame)
                                                    showTextField = false
                                                    newGameName = ""
                                                    errorMessage = nil  // Clear error message after adding
                                                }
                                            }
                                        }
                                    
                                    Button(action: {
                                        // Cancel action
                                        newGameName = ""
                                        showTextField = false
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .resizable()
                                            .foregroundColor(.red)
                                            .frame(width: 30, height: 30)
                                    }
                                }
                                .modifier(customViewModifier(roundedCornes: 6, startColor: .darkYellow, endColor: .yellow, textColor: .brown, width: 325, height: 75))
                                
                                if let errorMessage = errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                        .font(.subheadline)
                                        .padding(.top, 5)
                                }
                            }
                            .padding(.horizontal, 50)
                        } else {
                            Button(action: {
                                showTextField = true
                            }) {
                                Text("+  MAKE NEW SERIES  +")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                            .modifier(customViewModifier(roundedCornes: 6, startColor: .black, endColor: .red, textColor: .white, width: 325, height: 75))
                        }
                        
                        listOfSeriesView(collector: collector)
                        
                        HStack(spacing: 30){
                            Button {
                                showDeleteSheet = true
                            } label: {
                                HStack(spacing: 10) {
                                    Text("Delete a Series")
                                    Image(systemName: "trash.fill")
                                }
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            }
                        
                            
                            Button {
                                showHowTo = true
                            } label: {
                                HStack(spacing: 10) {
                                    Text("Guide")
                                    Image(systemName: "questionmark.circle.fill")
                                }
                                .foregroundStyle(.white)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                            }

                            
                            
                                
                        }
                        
                        
                    }
                    .padding(.top, 210) // Adjust this value to push the content down
                }
            }
            .sheet(isPresented: $showDeleteSheet, content: {
                deleteSheet(showSheet: $showDeleteSheet, sheet: collector)
                    .presentationDetents([.medium])
            })
            .sheet(isPresented: $showHowTo, content: {
                HowToUseView(showView: $showHowTo)
            })
        }
        .onAppear {
            loadSeriesData()
        }
    }
    
    private func loadSeriesData() {
        collector.loadSeries()
        // Simulate loading delay for demonstration purposes
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoading = false
        }
    }
}

#Preview {
    loadingScreen()
}
