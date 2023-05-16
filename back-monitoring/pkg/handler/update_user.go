package handler

import (
	"back-monitoring/model"
	"github.com/gin-gonic/gin"
	"net/http"
)

type UpdateUserResponse struct {
	Data model.User `json:"data"`
}

func (h *Handler) updateUser(c *gin.Context) {
	var input model.User

	if err := c.BindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	updatedUser, err := h.services.UpdateUser.UpdateUser(input)
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, UpdateUserResponse{Data: updatedUser})
}
