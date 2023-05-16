package handler

import (
	"back-monitoring/pkg/service"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
)

type Handler struct {
	services *service.Service
}

func NewHandler(services *service.Service) *Handler {
	return &Handler{services: services}
}

func (h *Handler) InitRoutes() *gin.Engine {
	router := gin.New()

	c := cors.New(cors.Config{
		AllowMethods:           []string{"GET", "POST", "PUT", "DELETE"},
		AllowHeaders:           []string{"*"},
		AllowCredentials:       true,
		ExposeHeaders:          []string{"*"},
		MaxAge:                 6000,
		AllowWildcard:          true,
		AllowBrowserExtensions: true,
		AllowWebSockets:        true,
		AllowFiles:             true,
		AllowOrigins:           []string{"*"},
	})
	router.Use(c)

	auth := router.Group("/auth")
	{
		auth.POST("/sign-up", h.signUp)
		auth.POST("/sign-in", h.signIn)
	}

	api := router.Group("/api", h.userIdentity)
	{
		api.GET("/hosts", h.getAllHosts)
		api.POST("/profile", h.getProfile)
		api.GET("/users", h.getAllUsers)
		api.POST("/host-info", h.getHostInfo)
		api.GET("/triggers", h.getAllTriggers)
		api.DELETE("/delete-user", h.deleteUser)
		api.POST("/update-user", h.updateUser)
	}

	return router
}
