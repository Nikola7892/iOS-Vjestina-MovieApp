
import Foundation

struct MovieDetailsModel: Decodable {
    let id: Int?
    let imageUrl: String?
    let name: String?
    let summary: String?
    let year: Int?
    let releaseDate: String?
    let rating: Double?
    let duration: Int?
    let categories: [MovieCategoryModel]?
    let crewMembers: [CrewMember]?
}

struct CrewMember: Decodable {
    let name: String
    let role: String
}

enum MovieCategoryModel: String, Decodable {
    case action = "ACTION"
    case adventure = "ADVENTURE"
    case comedy = "COMEDY"
    case crime = "CRIME"
    case drama = "DRAMA"
    case fantasy = "FANTASY"
    case romance = "ROMANCE"
    case scienceFiction = "SCIENCE_FICTION"
    case thriller = "THRILLER"
    case western = "WESTERN"
}
