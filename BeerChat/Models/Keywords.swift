//
//  Keywords.swift
//  BeerChat
//
//  Created by apple on 2023/07/16.
//

import Foundation

enum Keyword: String, CaseIterable {
    case competition
    case volunteer
    case bootcamp
    case campus
    
    var name: String {
        switch self {
        case .competition:
            return "공모전"
        case .volunteer:
            return "자원봉사"
        case .bootcamp:
            return "부트캠프"
        case .campus:
            return "대학생활"
        }
    }
    
    var detail: [String] {
        switch self {
        case .competition:
            return ["해커톤", "팀빌딩", "사이트"]
        case .volunteer:
            return ["농활", "해비타트", "봉사시간", "해외봉사"]
        case .bootcamp:
            return ["애플 디벨로퍼아카데미", "네이버 부스트캠프", "우형 우아한테크코스", "크래프톤 정글", "삼성 SSAFY"]
        case .campus:
            return ["학점 4.0", "학점 3.0", "전과", "공대", "미대", "외국어대", "전자정보대"]
        }
    }
}
