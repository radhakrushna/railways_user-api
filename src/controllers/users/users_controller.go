package users

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/radhakrushna/railways_user-api/src/domain/users"
	"github.com/radhakrushna/railways_user-api/src/services"
	"github.com/radhakrushna/railways_user-api/src/utils/errors"
)

func CreateUser(c *gin.Context) {
	var user users.User
	if err := c.ShouldBindJSON(&user); err != nil {
		restErr := errors.NewBadRequesterror("invalid json body")
		c.JSON(restErr.Status, restErr)
		return
	}

	result, saveError := services.CreateUser(user)
	if saveError != nil {
		c.JSON(saveError.Status, saveError)
		return
	}

	c.JSON(http.StatusCreated, result)
}

func GetUser(c *gin.Context) {
	userId, userErr := strconv.ParseInt(c.Param("user_id"), 10, 64)
	if userErr != nil {
		err := errors.NewBadRequesterror("user id should be a number")
		c.JSON(err.Status, err)
	}
	user, getError := services.GetUser(userId)
	if getError != nil {
		c.JSON(getError.Status, getError)
		return
	}

	c.JSON(http.StatusOK, user)
}
