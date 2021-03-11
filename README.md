# a RESTful API With Golang

## Build

```
go get github.com/google/uuid
go build
```

## Run
``` 
go get github.com/google/uuid
go run main.go
```

## Test
```
curl http://localhost
{
    "Method": "GET",
    "Path": "/",
    "Args": "",
    "Body": "",
    "Headers": {
        "Accept": "*/*",
        "User-Agent": "curl/7.64.1"
    },
    "Uuid": "f26bbebd-c15c-4a04-a6d9-97e45cb92095"
}
```

## Docker build
```
docker build -t go-restapi:latest .    
docker run -d -p "10000:10000" go-restapi:lastet
```
