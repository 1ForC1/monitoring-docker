package handler

import (
	"back-monitoring/model"
	"github.com/gin-gonic/gin"
	"net/http"
)

type getHostInfoResponse struct {
	Data model.HostInfo `json:"data"`
}

type HostInfoInput struct {
	HostId int `json:"hostid" binding:"required"`
}

func (h *Handler) getHostInfo(c *gin.Context) {
	var input HostInfoInput

	if err := c.BindJSON(&input); err != nil {
		newErrorResponse(c, http.StatusBadRequest, err.Error())
		return
	}

	hostinfo, err := h.services.HostInfo.GetHostInfo(input.HostId)
	if err != nil {
		newErrorResponse(c, http.StatusInternalServerError, err.Error())
		return
	}

	c.JSON(http.StatusOK, getHostInfoResponse{Data: hostinfo})
}
