import SwiftUI

struct CarsView: View {
    @EnvironmentObject var sideMenuState: SideMenuState
    @State private var isSearching = true
    @State private var searchText = ""
    @StateObject var dataManager = DataManager()
    
    var filteredCars: [Car] {
        if searchText.isEmpty {
            return dataManager.cars
        } else {
            let searchTerms = searchText.lowercased().split(separator: " ").map(String.init)
            return dataManager.cars.filter { car in
                searchTerms.allSatisfy { term in
                    car.make.lowercased().contains(term) ||
                    car.model.lowercased().contains(term) ||
                    "\(car.year)".contains(term) ||
                    car.trim.lowercased().contains(term) ||
                    car.vin.lowercased().contains(term)
                }
            }
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            GeometryReader { geometry in
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        ForEach(filteredCars, id: \.id) { car in
                            HStack(alignment: .top, spacing: 10) {
                                AsyncImage(url: URL(string: car.imageUrl)) { image in
                                    image.resizable()
                                } placeholder: {
                                    Color.gray
                                }
                                .frame(width: geometry.size.width * 0.3, height: 100)
                                .cornerRadius(10)
                                .padding(.horizontal, 10)
                                .padding(.vertical)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Link(destination: URL(string: "\(car.listing)")!) {
                                        Text("\(String(car.year)) \(car.make) \(car.model) \(car.trim)")
                                            .font(.headline)
                                            .foregroundColor(.black)
                                    }
                                    Text("Color: \(car.color)")
                                        .foregroundColor(.black)
                                    Text("Mileage: \(car.mileage)")
                                        .foregroundColor(.black)
                                    Text("Stock #: \(car.stock)")
                                        .foregroundColor(.black)
                                    Spacer()
                                    
                                    HStack {
                                        Spacer()
                                        Text("$\(car.price)")
                                            .bold()
                                            .padding()
                                            .background(Color.red)
                                            .foregroundColor(.white)
                                            .cornerRadius(10)
                                        Spacer()
                                    }
                                }
                                .padding(.vertical)
                            }
                            .frame(width: geometry.size.width)
                            .background(Color.white)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .padding(.bottom, 5)
                        }
                    }
                    .padding(.top, 130)
                }
                .background(Color.black)
            }
            
            TopBarView(
                title: "Drive Now",
                leftIconName: "line.3.horizontal",
                leftButtonAction: { sideMenuState.showMenu.toggle() },
                rightIconName: "line.horizontal.3.decrease.circle",
                rightButtonAction: {
                    print("Filter button tapped")
                },
                showSearchBar: false,
                isSearching: $isSearching,
                searchText: $searchText
            )
        }
    }
}

#Preview {
        CarsView()
        .environmentObject(SideMenuState())
}
