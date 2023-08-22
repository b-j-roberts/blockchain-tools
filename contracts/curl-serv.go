package main

import (
	"fmt"
	"log"
	"net/http"
)

func main() {
  integerHandler := func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "%d", 101)
  }

  http.HandleFunc("/integer", integerHandler)

  err := http.ListenAndServe(":5090", nil)
  if err != nil {
    log.Fatal("ListenAndServe: ", err)
  }
}

