package main

import "github.com/dhiguero/go-template/cmd/example-service-cli/commands"

// Version of the command
var Version string

// Commit from which the command was built
var Commit string

func main() {
	commands.Execute(Version, Commit)
}
