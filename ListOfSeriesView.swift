import SwiftUI


struct listOfSeriesView: View {
    @ObservedObject var collector: SeriesCollector
    
    var body: some View {
        ZStack{
            ScrollView {
                VStack(spacing: 25) {
                    ForEach(collector.arrayOfSeries.reversed()) { series in
                        NavigationLink(destination: tabbarview(gameModel: series)) {
                            
                            
                            HStack {
                                Spacer()
                                VStack {
                                    Text(series.name)
                                        .font(.title)
                                        .foregroundStyle(.black)
                                }
                                Spacer()
                                Image(systemName: "arrowshape.right")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .foregroundStyle(.black)
                            }                        
                        }
                        .modifier(customViewModifier(roundedCornes: 6, startColor: .yellow, endColor: .brown, textColor: .white, width: 325, height: 75))
                    }
                }
            }
            
        }
        
    }
}
