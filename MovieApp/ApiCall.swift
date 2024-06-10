import Foundation

class ApiCall {
    
    let apiUrl = "https://five-ios-api.herokuapp.com/api/v1/movie"
    
    func getMovies(from url: String) async throws -> [MovieModel] {
        guard let url = URL(string: url) else { throw URLError(.badURL)}
        
        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer Zpu7bOQYLNiCkT32V3c9BPoxDMfxisPAfevLW6ps", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        let moviesResponse = try JSONDecoder().decode([MovieModel].self, from: data)

        return moviesResponse
    }
    
    func getPopularMovies() async -> [MovieModel]{
        let criteria = ["FOR_RENT", "IN_THEATERS", "ON_TV", "STREAMING"]
        var popularMovies: [MovieModel] = []
        
        for criterion in criteria {
            let urlString = "\(apiUrl)/popular?criteria=\(criterion)"
            
            do {
                let movies = try await getMovies(from: urlString)
                popularMovies.append(contentsOf: movies)
            } catch {
                print("Failed to fetch movies: \(error)")
            }
        }
        
        popularMovies = removeDuplicates(from: popularMovies)
        return popularMovies
    }
    
    func getFreeToWatchMovies() async -> [MovieModel]{
        let criteria = ["MOVIE", "TV_SHOW"]
        var freeToWatchMovies: [MovieModel] = []
        
        for criterion in criteria {
            let urlString = "\(apiUrl)/free-to-watch?criteria=\(criterion)"
            
            do {
                let movies = try await getMovies(from: urlString)
                freeToWatchMovies.append(contentsOf: movies)
            } catch {
                print("Failed to fetch movies: \(error)")
            }
        }
    
        freeToWatchMovies = removeDuplicates(from: freeToWatchMovies)
        return freeToWatchMovies
    }
    
    func getTrendingMovies() async -> [MovieModel]{
        let criteria = ["THIS_WEEK", "TODAY"]
        var trendingMovies : [MovieModel] = []
        
        for criterion in criteria {
            let urlString = "\(apiUrl)/trending?criteria=\(criterion)"
            
            do {
                let movies = try await getMovies(from: urlString)
                trendingMovies.append(contentsOf: movies)
            } catch {
                print("Failed to fetch movies: \(error)")
            }
        }
        trendingMovies = removeDuplicates(from: trendingMovies)
        return trendingMovies
    }
    
    
    private func removeDuplicates(from movies: [MovieModel]) -> [MovieModel] {
        var uniqueMovies: [MovieModel] = []
        var uniqueIDs: Set<Int> = Set()
        
        for movie in movies {
            if let movieID = movie.id {
                if !uniqueIDs.contains(movieID) {
                    uniqueMovies.append(movie)
                    uniqueIDs.insert(movieID)
                }
            }
        }
        return uniqueMovies
    }
    
    
    
    func getMovieDetails(for movieID: Int) async throws -> MovieDetailsModel {
        guard let url = URL(string: "\(apiUrl)/\(movieID)/details") else {
            throw URLError(.badURL)
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("Bearer Zpu7bOQYLNiCkT32V3c9BPoxDMfxisPAfevLW6ps", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: urlRequest)

        let movieDetails = try JSONDecoder().decode(MovieDetailsModel.self, from: data)
        return movieDetails
    }

    
    func getAllMovies() async -> [MovieModel] {
        var allMovies: [MovieModel] = []
        
        let popularMovies = await getPopularMovies()
        let trendingMovies = await getTrendingMovies()
        let freeToWatchMovies = await getFreeToWatchMovies()
        
        allMovies.append(contentsOf: popularMovies)
        allMovies.append(contentsOf: trendingMovies)
        allMovies.append(contentsOf: freeToWatchMovies)
        
        allMovies = removeDuplicates(from: allMovies)
        
        return allMovies
    }

}

