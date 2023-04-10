package handler

import (
	"back-monitoring/model"
	"github.com/gin-gonic/gin"
	"net/http"
)

type getProfileResponse struct {
	Data model.User `json:"data"`
}

type ProfileInput struct {
	Login string `json:"login" binding:"required"`
}

func (h *Handler) getProfile(c *gin.Context) {
	var input ProfileInput

	if err := c.BindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	profile, err := h.services.Profile.GetProfile(input.Login)
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, getProfileResponse{Data: profile})
}
