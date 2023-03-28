package main

import (
	"back-monitoring"
	"back-monitoring/pkg/handler"
	"back-monitoring/pkg/repository"
	"back-monitoring/pkg/service"
	"github.com/joho/godotenv"
	"github.com/sirupsen/logrus"
	"github.com/spf13/viper"
	"os"
)

func main() {
	logrus.SetFormatter(new(logrus.JSONFormatter))

	if err := initConfig(); err != nil {
		logrus.Fatalf("error initializing configs: %s", err.Error())
	}

	if err := godotenv.Load(); err != nil {
		logrus.Fatalf("Error loading env variables: %s", err.Error())
	}

	db, err := repository.DBConnect(repository.ConfigStruct{
		HostDB:     viper.GetString("db.HostDB"),
		PortDB:     viper.GetInt("db.PortDB"),
		UserDB:     viper.GetString("db.UserDB"),
		PasswordDB: os.Getenv("PasswordDB"),
		DBName:     viper.GetString("db.DBName")})

	if err != nil {
		logrus.Fatalf("failed to initilize db: %s", err.Error())
	}

	repos := repository.NewRepository(db)
	services := service.NewService(repos)
	handlers := handler.NewHandler(services)
	srv := new(back_monitoring.Server)
	if err := srv.Run(viper.GetString("port"), handlers.InitRoutes()); err != nil {
		logrus.Fatalf("Error occured while running http server: %s", err.Error())
	}
}

func initConfig() error {
	viper.AddConfigPath("configs")
	viper.SetConfigName("config")
	return viper.ReadInConfig()
}
