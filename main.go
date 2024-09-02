package main

import (
	"fmt"

	"github.com/gigachad-dev-org/simz/db"
	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()

	// TODO: Add migrator when the time comes
	db.DatabaseInit()

	fmt.Printf("din mor er din far \n")
}
