package app

import (
	"github.com/radhakrushna/railways_user-api/src/controllers/ping"
	"github.com/radhakrushna/railways_user-api/src/controllers/users"
)

func mapUrls() {
	router.GET("/ping", ping.Ping)

	router.POST("/users", users.CreateUser)

	router.GET("/users/:user_id", users.GetUser)

}
