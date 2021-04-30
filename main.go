package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"

    	"math/rand"
)

var (
	host string
	port string
)

func init() {
	flag.StringVar(&host, "host", "localhost", "Host on which to run")
	flag.StringVar(&port, "port", "10000", "Port on which to run")
}

type Response struct {
	Method  string
	Path    string
	Args    string
	Body    string
	Headers map[string]string
	Uuid    string
}

func doNothing(w http.ResponseWriter, r *http.Request) {}

func requestTracker(w http.ResponseWriter, r *http.Request) {
	//fmt.Fprintf(w, "Welcome to the requestTracker!")
	id := randomString(10)

	headers := make(map[string]string)

	// Loop over header names
	for name, values := range r.Header {
		// Loop over all values for the name.
		for _, value := range values {
			headers[name] = value
			//fmt.Println(name, "=", value)
		}
	}

	body, _ := ioutil.ReadAll(r.Body)
	//fmt.Println(string(body))

	Responses := Response{Method: r.Method, Path: r.URL.Path, Args: string(r.URL.RawQuery), Body: string(body), Headers: headers, Uuid: id}

	//output, err := json.Marshal(Responses)
	output, err := json.MarshalIndent(Responses, "", "    ")
	if err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	w.Header().Set("content-type", "application/json")
	w.Write(output)
	fmt.Println(string(output))

	fmt.Println("Endpoint Hit: requestTracker")
}

func handleRequests() {
	http.HandleFunc("/favicon.ico", doNothing)
	http.HandleFunc("/", requestTracker)
	address := ":" + port

	log.Println("Starting server on address", address)
	err := http.ListenAndServe(address, nil)
	if err != nil {
		panic(err)
	}
}

func randomString(n int) string {
    var letters = []rune("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
 
    s := make([]rune, n)
    for i := range s {
        s[i] = letters[rand.Intn(len(letters))]
    }
    return string(s)
}

func main() {
	flag.Parse()
	handleRequests()
}
