//
//  GistFile.swift
//
struct GistFile: Codable {
    let filename: String
    let type: String
    let language: String?
    let rawUrl: String
    let size: Int

    private enum CodingKeys: String, CodingKey {
        case
        filename,
        type,
        language,
        rawUrl = "raw_url",
        size
    }
}
