//
//  StructClass.swift
//  Sports Updates
//
//  Created by Likith Burugu on 4/15/23.
//

import Foundation

struct ScoreStruct: Codable
{
    let Week : Int?
    let Date : String?
    let AwayTeam : String?
    let HomeTeam : String?
    let AwayScore : Int?
    let HomeScore : Int?
    let AwayScoreQuarter1 : Int?
    let AwayScoreQuarter2 : Int?
    let AwayScoreQuarter3 : Int?
    let AwayScoreQuarter4 : Int?
    let AwayScoreOvertime : Int?
    let HomeScoreQuarter1 : Int?
    let HomeScoreQuarter2 : Int?
    let HomeScoreQuarter3 : Int?
    let HomeScoreQuarter4 : Int?
    let HomeScoreOvertime : Int?
    let Status : String?
}

struct MLBScoreStruct: Codable
{
    
    let Game : Gameobject_datamodel?
    struct  Gameobject_datamodel  : Codable
    {
        
        let Season : Int?
        let AwayTeamID : Int?
        let HomeTeamID : Int?
        let AwayTeamRuns : Int?
        let HomeTeamRuns : Int?
        let AwayTeamHits : Int?
        let HomeTeamHits : Int?
        let AwayTeamErrors : Int?
        let HomeTeamErrors : Int?
        let Updated : String?
        let AwayTeam : String?
        let HomeTeam : String?
        let Status : String?
    }
}


struct StandingStruct: Codable
{
    let DivisionWins : Int?
    let DivisionLosses : Int?
    let Division : String?
    let Team : String?
    let Name : String?
    let Wins : Int?
    let Losses : Int?
    let Percentage : Float?
    
}

struct MLBStandingStruct: Codable
{
    let DivisionWins : Int?
    let DivisionLosses : Int?
    let Division : String?
    let Key : String?
    let Name : String?
    let Wins : Int?
    let Losses : Int?
    let Percentage : Float?
}

struct InjuriesStruct: Codable
{
    let Name : String?
    let Position : String?
    let Team : String?
    let Status : String?
    let Updated : String?
    
}

struct MLBInjuriesStruct: Codable
{
    let Name : String?
    let Position : String?
    let Team : String?
    let InjuryStatus : String?
    let DateTime : String?
}

struct FavoriteStruct: Codable
{
    let FullName : String?
    let City : String?
    let Conference : String?
    let Division : String?
    let Key : String?
    let HeadCoach : String?
    
}
