package handler

import (
	"back-monitoring/model"
	"github.com/gin-gonic/gin"
	"net/http"
)

type getAllUsersResponse struct {
	Data []model.User `json:"data"`
}

func (h *Handler) getAllUsers(c *gin.Context) {
	users, err := h.services.User.GetAll()
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, getAllUsersResponse{Data: users})
}
