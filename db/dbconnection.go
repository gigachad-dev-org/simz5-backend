package db

import (
	"fmt"
	"log"

	"github.com/gigachad-dev-org/simz/config"
	"gorm.io/driver/mysql"
	"gorm.io/gorm"
)

var con *gorm.DB

func DatabaseInit() {
	dbCredentials := config.GetDBConfig()

	dsn := fmt.Sprintf(
		"%s:%s@tcp(%s:%s)/%s?charset=utf8mb4&parseTime=True&loc=Local&allowNativePasswords=true&interpolateParams=true",
		dbCredentials.Username,
		dbCredentials.Password,
		dbCredentials.Host,
		dbCredentials.Port,
		dbCredentials.Database,
	)

	db, err := gorm.Open(mysql.Open(dsn), &gorm.Config{})
	if err != nil {
		log.Fatalf("failed to connect database: %s", err.Error())
	}
	con = db
}
