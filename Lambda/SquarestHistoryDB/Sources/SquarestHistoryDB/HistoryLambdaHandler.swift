//
//  HistoryLambdaHandler.swift
//  
//
//  Created by Erik Nordlund on 7/9/20.
//

import Foundation
import AWSLambdaEvents
import AWSLambdaRuntime
import AsyncHTTPClient
import DynamoDB

struct HistoryLambdaHandler: EventLoopLambdaHandler {
	typealias In = APIGateway.Request
	typealias Out = APIGateway.Response
	
	let db: DynamoDB.DynamoDB
	let historyService: HistoryService
	let httpClient: HTTPClient
	
	init(context: Lambda.InitializationContext) throws {
		let timeout = HTTPClient.Configuration.Timeout(
			connect: .seconds(30),
			read: .seconds(30))
		
		let httpClient = HTTPClient(
			eventLoopGroupProvider: .shared(context.eventLoop),
			configuration: HTTPClient.Configuration(timeout: timeout))
		
		let awsClient = AWSClient(httpClientProvider: .shared(httpClient))
		
		let tableName = Lambda.env("squarest-operation-history") ?? ""
		
		let region: Region
		if let envRegion = Lambda.env("AWS_REGION") {
			region = Region(rawValue: envRegion)
		} else {
			region = .uswest2
		}
		
		let db = DynamoDB.DynamoDB(client: awsClient, region: region)
		let historyService = HistoryService(db: db, tableName: tableName)
		
		self.httpClient = httpClient
		self.db = db
		self.historyService = historyService
	}
	
	func handle(context: Lambda.Context, event: APIGateway.Request) -> EventLoopFuture<APIGateway.Response> {
		
		return handleList(context: context, event: event)
	}
	
	func handleCreate(context: Lambda.Context, event: APIGateway.Request) -> EventLoopFuture<APIGateway.Response> {
		guard let history: HistoryItem = try? event.bodyObject() else {
			return context.eventLoop.makeSucceededFuture(APIGateway.Response(with: APIError.requestError, statusCode: .badRequest))
		}
		
		return historyService.create(item: history).map { (history) in
			APIGateway.Response(with: history, statusCode: .ok)
		}.flatMapError {
			self.catchError(context: context, error: $0)
		}
	}
	
	func handleRead(context: Lambda.Context, event: APIGateway.Request) -> EventLoopFuture<APIGateway.Response> {
		guard let id = event.pathParameters?[HistoryItem.DynamoDBField.id] else {
			return context.eventLoop.makeSucceededFuture(APIGateway.Response(with: APIError.requestError, statusCode: .badRequest))
		}
		
		#warning("TO DO: Make sure this takes the request parameters")
		return historyService.getItem(withID: id).map { (history) in
			APIGateway.Response(with: history, statusCode: .ok)
		}.flatMapError {
			self.catchError(context: context, error: $0)
		}
	}
	
	func handleList(context: Lambda.Context, event: APIGateway.Request) -> EventLoopFuture<APIGateway.Response> {
		guard let id = event.pathParameters?[HistoryItem.DynamoDBField.id] else {
			return context.eventLoop.makeSucceededFuture(APIGateway.Response(with: APIError.requestError, statusCode: .badRequest))
		}
		
		#warning("TO DO: Make sure this takes the request parameters")
		return historyService.getItems(forRequest: HistoryRequest(dateRange: nil, operationCategories: nil)).map { (history) in
			APIGateway.Response(with: history, statusCode: .ok)
		}.flatMapError {
			self.catchError(context: context, error: $0)
		}
	}
	
	func catchError(context: Lambda.Context, error: Error) -> EventLoopFuture<APIGateway.Response> {
		let response = APIGateway.Response(with: error, statusCode: .notFound)
		return context.eventLoop.makeSucceededFuture(response)
	}
}
