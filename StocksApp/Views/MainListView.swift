//
//  ContentView.swift
//  StocksApp
//
//  Created by Vaibhav on 01/05/23.
//

import SwiftUI
import XCAStocksAPI

struct MainListView: View {
    
    @EnvironmentObject var appVM: AppViewModel
    @StateObject var quotesVM = QuotesViewModel()
    @StateObject var searchVM = SearchViewModel()
    
    var body: some View {
        TabView{
            NavigationView {
                tickerListView
                    .listStyle(.plain)
                    .overlay { overlayView }
                    .toolbar{
                        titleToolbar
                        attributionToolbar
                    }
                    .searchable(text: $searchVM.query)
                    .refreshable {
                        await quotesVM.fetchQuotes(tickers: appVM.tickers)
                    }
                    .sheet(item: $appVM.selectedTicker) {
                        StockTickerView(chartVM: ChartViewModel(ticker: $0, apiService: quotesVM.stocksAPI), quoteVM: .init(ticker: $0,
                                                                                                                            stocksAPI: quotesVM.stocksAPI))
                        .presentationDetents([.height(560)])
                    }
                    .task(id: appVM.tickers){
                        await quotesVM.fetchQuotes(tickers: appVM.tickers)
                        
                    }
            }
            .tabItem {
            Image(systemName: "chart.bar.fill")
            Text("MarketWatch")
            }
            NavigationView {
                LearnView()
            }
            .tabItem {
                Image(systemName: "graduationcap")
                Text("Learn")
            }
            NavigationView {
                ContentView()
            }
            .tabItem {
                Image(systemName: "doc.plaintext.fill")
                Text("Blog")
            }
            NavigationView {
                ContentView1()
            }
            .tabItem {
                Image(systemName: "questionmark.circle.fill")
                Text("Ask Anything!")
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var tickerListView: some View {
        List {
            ForEach(appVM.tickers) { ticker in
                TickerListRowView(
                    data: .init(
                        symbol: ticker.symbol,
                        name: ticker.shortname,
                        price: quotesVM.priceForTicker(ticker),
                        type: .main))
                .contentShape(Rectangle())
                .onTapGesture {
                    appVM.selectedTicker = ticker
                }
            }
            .onDelete { appVM.removeTickers(atOffsets: $0) }
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        if appVM.tickers.isEmpty {
            EmptyStateView(text: appVM.emptyTickersText)
        }
        
        if searchVM.isSearching {
            SearchView(searchVM: searchVM)
        }
    }
    
    private var titleToolbar: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            VStack(alignment: .leading, spacing: -4) {
                Text(appVM.titleText)
                Text(appVM.subtitleText).foregroundColor(Color(uiColor: .secondaryLabel))
            }.font(.title2.weight(.heavy))
                .padding(.bottom)
        }
    }
    
    private var attributionToolbar: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                Button {
                    appVM.openYahooFinance()
                } label: {
                    Text(appVM.attributionText)
                        .font(.caption.weight(.heavy))
                        .foregroundColor(Color(uiColor: .secondaryLabel))
                }
                .buttonStyle(.plain)
                Spacer()
            }
        }
    }
    
    struct MainListView_Previews: PreviewProvider {
        
        @StateObject static var appVM: AppViewModel = {
            var mock = MockTickerListRepository()
            mock.stubbedLoad = { Ticker.stubs }
            return AppViewModel(repository: mock)
        }()
        
        @StateObject static var emptyAppVM: AppViewModel = {
            var mock = MockTickerListRepository()
            mock.stubbedLoad = { [] }
            return AppViewModel(repository: mock)
        }()
    
       static var quotesVM: QuotesViewModel = {
           var mock = MockStocksAPI()
           mock.stubbedFetchQuotesCallback = { Quote.stubs }
           return QuotesViewModel(stocksAPI: mock)
       }()
       
       static var searchVM: SearchViewModel = {
           var mock = MockStocksAPI()
           mock.stubbedSearchTickersCallback = { Ticker.stubs }
           return SearchViewModel(stocksAPI: mock)
       }()
        
        static var previews: some View {
            Group {
                NavigationStack {
                    MainListView(quotesVM: quotesVM, searchVM: searchVM)
                }
                .environmentObject(appVM)
                .previewDisplayName("With Tickers")
                
                NavigationStack {
                    MainListView(quotesVM: quotesVM, searchVM: searchVM)
                }
                .environmentObject(emptyAppVM)
                .previewDisplayName("With Empty Tickers")
            }
        }
    }
}
