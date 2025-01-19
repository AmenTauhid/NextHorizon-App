struct Job: Identifiable, Decodable {
    let id: Int?
    let job_title: String?
    let url: String?
    let date_posted: String?
    let company: String?
    let location: String?
    let description: String?

    enum CodingKeys: String, CodingKey {
        case id
        case job_title
        case url
        case date_posted
        case company
        case location
        case description
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        job_title = try values.decodeIfPresent(String.self, forKey: .job_title)
        url = try values.decodeIfPresent(String.self, forKey: .url)
        date_posted = try values.decodeIfPresent(String.self, forKey: .date_posted)
        company = try values.decodeIfPresent(String.self, forKey: .company)
        location = try values.decodeIfPresent(String.self, forKey: .location)
        description = try values.decodeIfPresent(String.self, forKey: .description)
    }
}
