package handler

import (
	"back-monitoring/model"
	"github.com/gin-gonic/gin"
	"net/http"
)

type DeleteUserResponse struct {
	Data model.User `json:"data"`
}

type DeleteUserInput struct {
	Login string `json:"login" binding:"required"`
}

func (h *Handler) deleteUser(c *gin.Context) {
	var input DeleteUserInput

	if err := c.BindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	deletedUser, err := h.services.DeleteUser.DeleteUser(input.Login)
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, DeleteUserResponse{Data: deletedUser})
}
