# S3Signer

[Vapor 4](https://vapor.codes/) Provider for [S3SignerAWS](https://github.com/JustinM1/S3SignerAWS)

Generates V4 authorization headers and pre-signed URLs for authenticating AWS S3 REST API requests
* Supports `DELETE/GET/HEAD/POST/PUT`

### Installation (SPM)
 ```ruby
.package(url: "https://github.com/sderiu/S3Signer", from: "2.0.0")
 ```

### Configuration

- Add in your configure.swift file:
```ruby
app.s3 = .init(accessKey: "YOUR_KEY",
               secretKey: "YOUR_SECRET",
               region: soneRegion, // -> See Region for available regions.
               securityToken: "YOUR_TEMP_TOKEN") 
```

### Usage
**Note:** Check [S3SignerAWS-README.md](https://github.com/JustinM1/S3SignerAWS/blob/master/README.md) for a detailed explanation on usage and capabilities.

S3Signer makes it extremely easy to generate V4 auth headers and pre-signed URLs by adding an extension to `Application` and `Request`.

##### V4 Auth Headers
- All required headers for the request are created automatically, with the option to add more for individual use cases.

###### Get
```ruby
func getS3TestImage(_ req: Request) {
  let url = URI(string:"https://example.region.digitaloceanspaces.com/bucket/TestImage.jpg")
  guard let headers = try req.s3.authHeaderV4(
    httpMethod: .get,
    urlString: urlString,
    headers: [:],
    payload: .none) else { throw Abort.serverError }

  let vaporHeaders = headers.vaporHeaders

  let resp = try self.req.client.get(url, headers: vaporHeaders)
 }
```

###### PUT
```ruby
func putS3TestImage(_ req: Request) {
  let url = URI(string: "https://example.region.digitaloceanspaces.com/bucket")
  
  guard let payload = Data(buffer: req.body.data),
  let headers = try req.s3.authHeaderV4(
    httpMethod: .put,
    urlString: urlString,
    headers: [:],
    payload: .data(payload)) else { throw Abort.serverError }

  let vaporHeaders = headers.vaporHeaders

  let resp = try req.client.put(
    urlString, headers:
    vaporHeaders){ request in 
      request.body = req.body.data
    }
}
```

##### V4 Pre-Signed URL

###### Get
```ruby
let url = URI(string:"https://example.region.digitaloceanspaces.com/bucket/TestImage.jpg")

guard let presignedURLString = try req.s3.presignedURLV4(
   httpMethod: .get,
   urlString: urlString,
   expiration: TimeFromNow.oneHour,
   headers: [:]) else { throw Abort.serverError }

let resp = try req.client.get(
  preSignedURLString,
  headers: [:])
```
###### PUT
```ruby
let url = URI(string:"https://example.region.digitaloceanspaces.com/bucket/TestImage.jpg")

 guard let payload = Data(buffer: req.body.data),
 let preSignedURLString = try req.s3.presignedURLV4(
   httpMethod: .put,
   urlString: urlString,
   expiration: .thirtyMinutes,
   headers: [:]) else { throw Abort.badReqest }

 let resp = try self.drop.client.put(
   preSignedURLString,
   headers: [:]){ request in 
      request.body = req.body.data
   }
```
* `TimeFromNow` has three default lengths, `30 minutes, 1 hour, and 3 hours`. There is also a custom option which takes `Seconds`: `typealias for Int`.
