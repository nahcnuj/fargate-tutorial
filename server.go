package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	_ "time/tzdata"

	"github.com/go-chi/chi"
)

func main() {
	local, err := time.LoadLocation("Asia/Tokyo")
	if err != nil {
		panic("timezone could not be loaded!")
	}
	time.Local = local

	mux := chi.NewRouter()
	mux.Get("/health", health)
	mux.Get("/", index)

	log.Println("listening on http://localhost:3000")
	http.ListenAndServe(":3000", mux)
}

func health(w http.ResponseWriter, _ *http.Request) {
	w.WriteHeader(http.StatusOK)
	w.Write([]byte(fmt.Sprint("ok ", time.Now().Format(time.RFC3339))))
}

func index(w http.ResponseWriter, _ *http.Request) {
	out := struct {
		OK   bool
		Date string
	}{
		OK:   true,
		Date: time.Now().Format(time.RFC3339),
	}
	w.Header().Add("Content-Type", "application/json; charset=utf-8")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(out)
}
