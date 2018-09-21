//
//  Harvest.swift
//  Timesheets
//
//  Created by Rhys Powell on 8/7/18.
//  Copyright © 2018 Rhys Powell. All rights reserved.
//

import Foundation
import Moya

public class APIKeys {
    public static let shared = APIKeys()

    public let personalAccessToken: String
    public let accountID: String

    public init() {
        guard let plistURL = Bundle.main.url(forResource: "APIKeys", withExtension: "plist"),
            let plistData = try? Data(contentsOf: plistURL),
            let plist = try? PropertyListDecoder().decode([String: String].self, from: plistData)
        else {
            fatalError("Unable to load API Keys")
        }

        self.personalAccessToken = plist["PersonalAccessToken"]!
        self.accountID = plist["AccountID"]!
    }
}

public enum Harvest {
    case currentUserProjectAssignments
    case submitTimeEntry(projectID: Int, taskID: Int, date: Date)
}

extension Harvest: TargetType {
    public static let jsonEncoder: JSONEncoder = {
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .iso8601
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        return jsonEncoder
    }()

    public static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        return jsonDecoder
    }()

    public var baseURL: URL {
        return URL(string: "https://api.harvestapp.com")!
    }

    public var path: String {
        switch self {
        case .currentUserProjectAssignments:
            return "/v2/users/me/project_assignments"
        case .submitTimeEntry:
            return "/v2/time_entries"
        }
    }

    public var method: Moya.Method {
        switch  self {
        case .currentUserProjectAssignments:
            return .get
        case .submitTimeEntry:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .currentUserProjectAssignments:
            return .requestPlain
        case let .submitTimeEntry(projectID, taskID, date):
            return .requestCustomJSONEncodable(TimeEntryRequest(
                projectId: projectID,
                taskId: taskID,
                spentDate: date,
                hours: 8
            ), encoder: Harvest.jsonEncoder)
        }
    }

    public var headers: [String : String]? {
        return [
            "Authorization": "Bearer \(APIKeys.shared.personalAccessToken)",
            "Harvest-Account-Id": APIKeys.shared.accountID,
            "User-Agent": Bundle.main.bundleIdentifier ?? "Timesheets <rhys@rpowell.me>"
        ]
    }

    public var sampleData: Data {
        switch self {
        case .currentUserProjectAssignments:
            return """
            {
              "project_assignments":[
                {
                  "id":125066109,
                  "is_project_manager":true,
                  "is_active":true,
                  "budget":null,
                  "created_at":"2017-06-26T21:52:18Z",
                  "updated_at":"2017-06-26T21:52:18Z",
                  "hourly_rate":100.0,
                  "project":{
                    "id":14308069,
                    "name":"Online Store - Phase 1",
                    "code":"OS1"
                  },
                  "client":{
                    "id":5735776,
                    "name":"123 Industries"
                  },
                  "task_assignments":[
                    {
                      "id":155505013,
                      "billable":true,
                      "is_active":true,
                      "created_at":"2017-06-26T21:52:18Z",
                      "updated_at":"2017-06-26T21:52:18Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083365,
                        "name":"Graphic Design"
                      }
                    },
                    {
                      "id":155505014,
                      "billable":true,
                      "is_active":true,
                      "created_at":"2017-06-26T21:52:18Z",
                      "updated_at":"2017-06-26T21:52:18Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083366,
                        "name":"Programming"
                      }
                    },
                    {
                      "id":155505015,
                      "billable":true,
                      "is_active":true,
                      "created_at":"2017-06-26T21:52:18Z",
                      "updated_at":"2017-06-26T21:52:18Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083368,
                        "name":"Project Management"
                      }
                    },
                    {
                      "id":155505016,
                      "billable":false,
                      "is_active":true,
                      "created_at":"2017-06-26T21:52:18Z",
                      "updated_at":"2017-06-26T21:54:06Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083369,
                        "name":"Research"
                      }
                    }
                  ]
                },
                {
                  "id":125063975,
                  "is_project_manager":true,
                  "is_active":true,
                  "budget":null,
                  "created_at":"2017-06-26T21:36:23Z",
                  "updated_at":"2017-06-26T21:36:23Z",
                  "hourly_rate":100.0,
                  "project":{
                    "id":14307913,
                    "name":"Marketing Website",
                    "code":"MW"
                  },
                  "client":{
                    "id":5735774,
                    "name":"ABC Corp"
                  },
                  "task_assignments":[
                    {
                      "id":155502709,
                      "billable":true,
                      "is_active":true,
                      "created_at":"2017-06-26T21:36:23Z",
                      "updated_at":"2017-06-26T21:36:23Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083365,
                        "name":"Graphic Design"
                      }
                    },
                    {
                      "id":155502710,
                      "billable":true,
                      "is_active":true,
                      "created_at":"2017-06-26T21:36:23Z",
                      "updated_at":"2017-06-26T21:36:23Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083366,
                        "name":"Programming"
                      }
                    },
                    {
                      "id":155502711,
                      "billable":true,
                      "is_active":true,
                      "created_at":"2017-06-26T21:36:23Z",
                      "updated_at":"2017-06-26T21:36:23Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083368,
                        "name":"Project Management"
                      }
                    },
                    {
                      "id":155505153,
                      "billable":false,
                      "is_active":true,
                      "created_at":"2017-06-26T21:53:20Z",
                      "updated_at":"2017-06-26T21:54:31Z",
                      "hourly_rate":100.0,
                      "budget":null,
                      "task":{
                        "id":8083369,
                        "name":"Research"
                      }
                    }
                  ]
                }
              ],
              "per_page":100,
              "total_pages":1,
              "total_entries":2,
              "next_page":null,
              "previous_page":null,
              "page":1,
              "links":{
                "first":"https://api.harvestapp.com/v2/users/1782884/project_assignments?page=1&per_page=100",
                "next":null,
                "previous":null,
                "last":"https://api.harvestapp.com/v2/users/1782884/project_assignments?page=1&per_page=100"
              }
            }
            """.data(using: .utf8)!
        case .submitTimeEntry:
            return """
            {
              "id":636718192,
              "spent_date":"2017-03-21",
              "user":{
                "id":1782959,
                "name":"Kim Allen"
              },
              "client":{
                "id":5735774,
                "name":"ABC Corp"
              },
              "project":{
                "id":14307913,
                "name":"Marketing Website"
              },
              "task":{
                "id":8083365,
                "name":"Graphic Design"
              },
              "user_assignment":{
                "id":125068553,
                "is_project_manager":true,
                "is_active":true,
                "budget":null,
                "created_at":"2017-06-26T22:32:52Z",
                "updated_at":"2017-06-26T22:32:52Z",
                "hourly_rate":100.0
              },
              "task_assignment":{
                "id":155502709,
                "billable":true,
                "is_active":true,
                "created_at":"2017-06-26T21:36:23Z",
                "updated_at":"2017-06-26T21:36:23Z",
                "hourly_rate":100.0,
                "budget":null
              },
              "hours":1.0,
              "notes":null,
              "created_at":"2017-06-27T16:01:23Z",
              "updated_at":"2017-06-27T16:01:23Z",
              "is_locked":false,
              "locked_reason":null,
              "is_closed":false,
              "is_billed":false,
              "timer_started_at":null,
              "started_time":null,
              "ended_time":null,
              "is_running":false,
              "invoice":null,
              "external_reference": null,
              "billable":true,
              "budgeted":true,
              "billable_rate":100.0,
              "cost_rate":50.0
            }
            """.data(using: .utf8)!
        }
    }
}
