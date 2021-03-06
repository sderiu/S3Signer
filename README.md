# VaporS3Signer

[Vapor](https://vapor.codes/) Provider for [S3SignerAWS](https://github.com/JustinM1/S3SignerAWS)

Generates V4 authorization headers and pre-signed URLs for authenticating AWS S3 REST API requests
* Supports `DELETE/GET/HEAD/POST/PUT`

### Installation (SPM)
 ```ruby
.Package(url: "https://github.com/sderiu/S3Signer", from: "1.0.0")
 ```

### Config File

- Add `vapor-S3Signer.json` file to your Config/secrets folder.

The `vapor-S3Signer.json` file should contain your access key, secret key, and the region of your bucket. You can also include a temporary token for EC2 instance which is optional.

Ex.
```ruby
{
"accessKey": "someKey",
"secretKey": "someSecretKey",
"region": "someRegionName",
"securityToken": "someTempToken"
}
```
Here are the names for each region:
##### CA
* Canada (Central) = `"ca-central-1"`

##### US
* US East 1 Virginia = `"us-east-1"`
* US East 2 Ohio = `"us-east-2"`
* US West 1 = `"us-west-1"`
* US West 2 = `"us-west-2"`

##### EU

* EU West 1 = `"eu-west-1"`
* EU West 2 = `"eu-west-2"`
* EU Central 1 = `"eu-central-1"`

##### AP

* AP South 1 = `"ap-south-1"`
* AP Southeast 1 = `"ap-southeast-1"`
* AP Southeast 2 = `"ap-southeast-2"`
* AP Northeast 1 = `"ap-northeast-1"`
* AP Northeast 2 = `"ap-northeast-2"`

##### SA

* SA East 1 = `"sa-east-1"`

### Usage
**Note:** Check [S3SignerAWS-README.md](https://github.com/JustinM1/S3SignerAWS/blob/master/README.md) for a detailed explanation on usage and capabilities.

VaporS3Signer makes it extremely easy to generate V4 auth headers and pre-signed URLs by adding an extension to `Droplet`.

##### V4 Auth Headers
- All required headers for the request are created automatically, with the option to add more for individual use cases.

###### Get
```ruby
drop.get("getS3TestImage") { req in
let urlString = "https://" + Region.usEast1_Virginia.host.appending("S3bucketname/users/\(someUserId)")

  guard let headers = try drop.s3Signer?.authHeaderV4(
    httpMethod: .get,
    urlString: urlString,
    headers: [:],
    payload: .none) else { throw Abort.serverError }

  let vaporHeaders = headers.vaporHeaders

  let resp = try self.drop.client.get(urlString, headers: vaporHeaders, query: [:])
 }
```

###### PUT
```ruby
drop.post("users/image") { req in
  let urlString = "https://" + Region.usEast1_Virginia.host.appending("S3bucketname/users/\(someUserId)")

  guard let payload = req.body.bytes,
  let headers = try self.drop.s3Signer?.authHeaderV4(
    httpMethod: .put,
    urlString: urlString,
    headers: [:],
    payload: Payload.bytes(payload)) else { throw Abort.serverError }

  let vaporHeaders = headers.vaporHeaders

  let resp = try self.drop.client.put(
    urlString, headers:
    vaporHeaders, query: [:],
    body: Body(payload))
}
```

##### V4 Pre-Signed URL

###### Get
```ruby
let urlString = "https://" + Region.usEast1_Virginia.host.appending("S3bucketname/users/\(someUserId)")

guard let presignedURLString = try drop.s3Signer?.presignedURLV4(
   httpMethod: .get,
   urlString: urlString,
   expiration: TimeFromNow.oneHour,
   headers: [:]) else { throw Abort.serverError }

let resp = try self.drop.client.get(
  preSignedURLString,
  headers: [:],
  query: [:])
```
###### PUT
```ruby
 let urlString = "https://" + Region.usEast1_Virginia.host.appending("S3bucketname/users/\(someUserId)")

 guard let payload = req.body.bytes,
 let preSignedURLString = try self.drop.s3Signer?.presignedURLV4(
   httpMethod: .put,
   urlString: urlString,
   expiration: .thirtyMinutes,
   headers: [:]) else { throw Abort.badReqest }

 let resp = try self.drop.client.put(
   preSignedURLString,
   headers: [:],
   query: [:],
   body: Body(payload))
```
* `TimeFromNow` has three default lengths, `30 minutes, 1 hour, and 3 hours`. There is also a custom option which takes `Seconds`: `typealias for Int`.
